class DateBuilder {
  int? year;
  int? month;
  int? day;
  int? hour;
  int? minute;
  int? second;
  int? millisecond;
  int? microsecond;

  DateBuilder today() {
    var now = DateTime.now();

    return setYear(now.year).setMonth(now.month).setDay(now.day);
  }

  DateBuilder dayStart() {
    return setHour(0)
        .setMinute(0)
        .setSecond(0)
        .setMillisecond(0)
        .setMicrosecond(0);
  }

  DateBuilder setYear(int y) {
    year = y;
    return this;
  }

  DateBuilder setMonth(int m) {
    month = m;
    return this;
  }

  DateBuilder setDay(int d) {
    day = d;
    return this;
  }

  DateBuilder setHour(int h) {
    hour = h;
    return this;
  }

  DateBuilder setMinute(int m) {
    minute = m;
    return this;
  }

  DateBuilder setSecond(int s) {
    second = s;
    return this;
  }

  DateBuilder setMillisecond(int m) {
    millisecond = m;
    return this;
  }

  DateBuilder setMicrosecond(int m) {
    microsecond = m;
    return this;
  }

  DateTime build() {
    var now = DateTime.now();

    return DateTime(
      year ?? now.year,
      month ?? now.month,
      day ?? now.day,
      hour ?? now.hour,
      minute ?? now.minute,
      second ?? now.second,
      millisecond ?? now.millisecond,
      microsecond ?? now.microsecond,
    );
  }
}
