import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:job_task_event/utils/inward_curved_clipper.dart';


void main() {
  test('InwardCurvedClipper returns a valid path', () {
    final clipper = InwardCurvedClipper();
    final path = clipper.getClip(Size(300, 200));

    expect(path, isA<Path>());
    expect(path.getBounds().width, greaterThan(0));
    expect(path.getBounds().height, greaterThan(0));
  });

  test('InwardCurvedClipper should not reclip on same size', () {
    final clipper = InwardCurvedClipper();
    expect(clipper.shouldReclip(InwardCurvedClipper()), false);
  });
}
