import 'package:lottie/lottie.dart';

LottieBuilder defaultLoading({double width = 50}) {
  return Lottie.asset(
    "assets/json/loading.json",
    width: width,
  );
}


LottieBuilder defaultError({double width = 50}) {
  return Lottie.asset(
    "assets/json/error.json",
    width: width,
  );
}

