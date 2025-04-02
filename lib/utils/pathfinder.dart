import 'dart:math';
import 'package:collection/collection.dart';
import 'package:path_tracer_app/entities.dart/index.dart';
import 'grid.dart';

List<Coordinates> _directions = [
  Coordinates(-1, -1), Coordinates(0, -1), Coordinates(1, -1),
  Coordinates(-1, 0),               Coordinates(1, 0),
  Coordinates(-1, 1),  Coordinates(0, 1), Coordinates(1, 1)
];

const _sidesSumToDiagonalMove = 2; 

class Pathfinder {
  final Grid grid;
  final List<List<Node>> nodes = [];

  final Function(int) emitProgressEvent; 

  Pathfinder({required this.grid, required this.emitProgressEvent}) {
    generateNodes();
  }

  Future<List<Coordinates>> findPath(Coordinates start, Coordinates end) async{
    final startNode = nodes[start.y][start.x];
    startNode.startToNodeCost = 0;
    startNode.nodeToEndCost = calcHodeToEndCost(startNode, end);
    
    final endNode = nodes[end.y][end.x];
    
    final toCheckNodesSet = PriorityQueue<Node>((a, b) => a.fCost.compareTo(b.fCost));
    final checkedNodesSet = <Coordinates>{};

    toCheckNodesSet.add(startNode);

    while(toCheckNodesSet.isNotEmpty){
      final currentNode = toCheckNodesSet.removeFirst();
      checkedNodesSet.add(currentNode.coordinates);

      if(currentNode.coordinates == endNode.coordinates){
        changeProgress(toCheckNodesSet.length, checkedNodesSet.length);
        return _reconstructPath(currentNode);
      }

      for (var direction in _directions) {
        final newCoordinates = currentNode.coordinates + direction;
        if (newCoordinates.x < 0 ||
            newCoordinates.x >= nodes[0].length ||
            newCoordinates.y < 0 ||
            newCoordinates.y >= nodes.length) {
          continue;
        }
        final neighbor = nodes[newCoordinates.y][newCoordinates.x];
        if(checkedNodesSet.contains(neighbor.coordinates)) continue;
        double startToNeigthborConst = 
          currentNode.startToNodeCost + (direction.x.abs() + direction.y.abs() == _sidesSumToDiagonalMove ? sqrt2 : 1);
        if(startToNeigthborConst < neighbor.startToNodeCost){
          neighbor.parent = currentNode;
          neighbor.startToNodeCost = startToNeigthborConst;
          neighbor.nodeToEndCost+= calcHodeToEndCost(neighbor, endNode.coordinates);
           if (!toCheckNodesSet.contains(neighbor)) {
            toCheckNodesSet.add(neighbor);
            changeProgress(toCheckNodesSet.length, checkedNodesSet.length);
          }
        }
      }
      changeProgress(toCheckNodesSet.length, checkedNodesSet.length);
    }
    return []; 
  }
  
  void generateNodes () {
    for (int i = 0; i < grid.matrix.length; i++) {
      nodes.add([]);
      for (var cell in grid.matrix[i]) {
        nodes[i].add(Node(
          coordinates: Coordinates(cell.coordinates.x, cell.coordinates.y),
          parent: null,
          nodeToEndCost: cell.isAvailable ? 0 : double.infinity)
        );
      }
    }
  }

  void changeProgress(int openSetLength, int closedSetLength) {
    emitProgressEvent(((openSetLength + closedSetLength) / (grid.matrix.length * grid.matrix[0].length) * 100).floor());
  }

  double calcHodeToEndCost(Node node, Coordinates end) {
    final distance = node.coordinates - end;
    return sqrt(distance.x * distance.x + distance.y * distance.y);
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
  double startToNodeCost;
  double nodeToEndCost;

  Node({required this.coordinates, required this.parent, this.startToNodeCost = double.infinity, this.nodeToEndCost = 0});
  double get fCost => startToNodeCost + nodeToEndCost;
}