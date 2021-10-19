import 'package:ourprint/resources/images.dart';

class ConfigurationItems {
  static const a4 = 'A4 Size';
  static const color = 'Colour';
  static const bAndW = 'B&W';
  static const oneSided = 'One Sided';
  static const twoSided = 'Two Sided';
  static const spiralBind = 'Spiral Bind';
  static const loosePapers = 'Loose Papers';
  static const stapledCopy = 'Stapled Copy';

  static Map<String, String> configurations = {
    a4: Images.a4,
    color: Images.color,
    bAndW: Images.bW,
    oneSided: Images.oneSided,
    twoSided: Images.twoSided,
    spiralBind: Images.spiralBind,
    loosePapers: Images.loosePapers,
    stapledCopy: Images.stapledCopy,
  };
}
