{ applyPatches, brewSrc }:
# Backport Tahoe detection while retaining the pinned Ruby 3.3 runtime.
(applyPatches {
  name = "brew-4.4.5-tahoe";
  src = brewSrc;
  patches = [
    (builtins.toFile "homebrew-tahoe.patch" ''
      --- a/Library/Homebrew/macos_version.rb
      +++ b/Library/Homebrew/macos_version.rb
      @@ -21,6 +21,7 @@
         # NOTE: When removing symbols here, ensure that they are added
         #       to `DEPRECATED_MACOS_VERSIONS` in `MacOSRequirement`.
         SYMBOLS = {
      +    tahoe:       "26",
           sequoia:     "15",
           sonoma:      "14",
           ventura:     "13",
      @@ -40,7 +41,9 @@
         sig { params(macos_version: MacOSVersion).returns(Version) }
         def self.kernel_major_version(macos_version)
           version_major = macos_version.major.to_i
      -    if version_major > 10
      +    if version_major >= 26
      +      Version.new((version_major - 1).to_s)
      +    elsif version_major > 10
             Version.new((version_major + 9).to_s)
           else
             version_minor = macos_version.minor.to_i
      @@ -56,3 +59,3 @@
         sig { params(version: T.nilable(String)).void }
         def initialize(version)
      -    raise MacOSVersion::Error, version unless /\A1\d+(?:\.\d+){0,2}\Z/.match?(version)
      +    raise MacOSVersion::Error, version unless /\A\d{2,}(?:\.\d+){0,2}\z/.match?(version)
    '')
  ];
})
// {
  version = "4.4.5";
}
