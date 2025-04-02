import 'package:flutter/material.dart';
import 'package:path_tracer_app/entities.dart/index.dart';
import 'package:path_tracer_app/styles.dart';

class Grid{
  List<List<Cell>> matrix = [];

  Grid._(this.matrix);

  factory Grid.generateFromMatrix(List<List<bool>> matrix) {
    final List<List<Cell>> grid = [];
    for(int i = 0; i < matrix.length; i++){
      grid.add([]);
      for(int j = 0; j < matrix[i].length; j++){
        grid[i].add(Cell(coordinates: Coordinates(j, i), isAvailable: matrix[i][j]));
      }
    }
    return Grid._(grid);
  }

  Widget buildGridWithPath(Coordinates start, Coordinates end, List<Coordinates> path) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: matrix.map((row) {
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: row.map((cell) {
                    Color cellColor = cell.isAvailable ? emptyCellColor : blockedCellColor;
                    TextStyle textStyle = cellTextStyle.copyWith(
                      color: cell.isAvailable ? Colors.black : Colors.white
                    );

                    if (cell.coordinates == start) {
                      cellColor = startCellColor;
                      textStyle = cellTextStyle;
                    } else if (cell.coordinates == end) {
                      cellColor = endCellColor;
                      textStyle = cellTextStyle;
                    } else if (path.contains(cell.coordinates)) {
                      cellColor = pathCellColor;
                      textStyle = cellTextStyle;
                    }

                    final width = constraints.maxWidth / row.length;
                    final height = constraints.maxHeight / matrix.length;

                    return Container(
                      width: width > 50 ? width : 50,
                      height: height > 50 ? height : 50,
                      decoration: BoxDecoration(
                        color: cellColor,
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Center(
                        child: Text(
                          cell.coordinates.toString(),
                          style: textStyle,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }
}

class Cell{
  final Coordinates coordinates;
  final bool isAvailable;

  Cell({required this.coordinates, this.isAvailable = true});

  @override
  String toString() {
    return 'Cell(x: ${coordinates.x} y: ${coordinates.y} $isAvailable)';
  }
}