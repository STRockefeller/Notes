
簡單描述一下開發時遇到的手勢判定問題。有空再來整理。

```dart
onPanEnd: (details) {
          if (details.velocity.pixelsPerSecond.dx > 0) {
            _move(Direction.right);
          } else if (details.velocity.pixelsPerSecond.dx < 0) {
            _move(Direction.left);
          } else if (details.velocity.pixelsPerSecond.dy > 0) {
            _move(Direction.down);
          } else if (details.velocity.pixelsPerSecond.dy < 0) {
            _move(Direction.up);
          }
        },
```

這個寫法會造成上下判定幾乎無法達成，因為人類不太可能在上下滑動時不帶任何水平移動。

```dart
 onPanEnd: (details) {
          const threshold = 20;
          final dx = details.velocity.pixelsPerSecond.dx;
          final dy = details.velocity.pixelsPerSecond.dy;
          if (dx.abs() > dy.abs()) {
            if (dx > threshold) {
              _move(Direction.right);
            } else if (dx < -threshold) {
              _move(Direction.left);
            }
          } else {
            if (dy > threshold) {
              _move(Direction.down);
            } else if (dy < -threshold) {
              _move(Direction.up);
            }
          }
        },
```

解法就是加入一個標準值，只有移動超過標準量才會觸發方法。