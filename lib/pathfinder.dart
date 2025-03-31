import 'dart:math';
import 'package:collection/collection.dart';
import 'package:path_tracer_app/entities.dart/index.dart';

List<List<int>> directions = [
  [-1, -1], [0, -1], [1, -1],
  [-1, 0],         [1, 0],
  [-1,1], [0, 1], [1, 1]
];

class Pathfinder {
  final Grid grid;
  final List<List<Node>> nodes = [];

  final Function(int) emitProgressEvent; 

  Pathfinder({required this.grid, required this.emitProgressEvent}) {
    generateNodes();
  }

  List<Coordinates> findPath(Coordinates start, Coordinates end) {
    final startNode = nodes[start.y][start.x];
    startNode.gCost = 0;
    startNode.hCost = calcHCost(startNode, end);
    
    final endNode = nodes[end.y][end.x];
    
    final openSet = PriorityQueue<Node>((a, b) => a.fCost.compareTo(b.fCost));
    final closedSet = <Coordinates>{};

    openSet.add(startNode);

    while(openSet.isNotEmpty){
      final currentNode = openSet.removeFirst();
      closedSet.add(currentNode.coordinates);

      if(currentNode.coordinates == endNode.coordinates){
        changeProgress(openSet.length, closedSet.length);
        return _reconstructPath(currentNode);
      }

      for (var direction in directions) {
        final newCoordinates = Coordinates(
          x: currentNode.coordinates.x + direction[0],
          y: currentNode.coordinates.y + direction[1],
        );
        if(newCoordinates.x < 0 || newCoordinates.x >= nodes.length || newCoordinates.y < 0 || newCoordinates.y >= nodes.length) {
          continue;
        }
        final neighbor = nodes[newCoordinates.y][newCoordinates.x];
        if(closedSet.contains(neighbor.coordinates)) continue;
        double tentativeG = currentNode.gCost + (direction[0].abs() + direction[1].abs() == 2 ? sqrt2 : 1);
        if(tentativeG < neighbor.gCost){
          neighbor.parent = currentNode;
          neighbor.gCost = tentativeG;
          neighbor.hCost+= calcHCost(neighbor, endNode.coordinates);
           if (!openSet.contains(neighbor)) {
            openSet.add(neighbor);
            changeProgress(openSet.length, closedSet.length);
          }
        }
      }
      changeProgress(openSet.length, closedSet.length);
    }
    return []; 
  }
  
  void generateNodes () {
    for (int i = 0; i < grid.grid.length; i++) {
      nodes.add([]);
      for (var cell in grid.grid[i]) {
        nodes[i].add(Node(
          coordinates: Coordinates(x: cell.x, y: cell.y),
          parent: null,
          hCost: cell.isAvailable ? 0 : double.infinity)
        );
      }
    }
  }

  void changeProgress(int openSetLength, int closedSetLength) {
    emitProgressEvent((openSetLength + closedSetLength / (grid.grid.length * grid.grid.length) * 100).toInt());
  }

  double calcHCost(Node node, Coordinates end) {
    final dx = (node.coordinates.x - end.x).abs();
    final dy = (node.coordinates.y - end.y).abs();
    return sqrt(dx * dx + dy * dy);
  }

  List<Coordinates> _reconstructPath(Node lastNode) {
    Node? node = lastNode; 
    List<Coordinates> path = [];
    while (node != null) {
      path.add(node.coordinates);
      node = node.parent;
    }
    return path.reversed.toList();
  }
}


class Node{
  final Coordinates coordinates;
  Node? parent;
  double gCost;
  double hCost;

  Node({required this.coordinates, required this.parent, this.gCost = double.infinity, this.hCost = 0});
  double get fCost => gCost + hCost;
}

class Grid{
  List<List<Cell>> grid = [];

  Grid._(this.grid);

  factory Grid.generateFromMatrix(List<List<bool>> matrix) {
    final List<List<Cell>> grid = [];
    for(int i =0; i < matrix.length; i++){
      grid.add([]);
      for(int j = 0; j < matrix[i].length; j++){
        grid[i].add(Cell(x: j, y: i, isAvailable: matrix[i][j]));
      }
    }
    return Grid._(grid);
  }

}

class Cell{
  final int x;
  final int y;
  final bool isAvailable;

  Cell({required this.x, required this.y, this.isAvailable = true});

  @override
  String toString() {
    return 'Cell(x: $x, y: $y $isAvailable)';
  }
}