//=============================================================================
// Bitmap: An abstract bitmap.
// This is a built-in Unreal class and it shouldn't be modified.
//=============================================================================
class Bitmap extends Object
	native
	noexport;

// Texture format.
var(Info) const editconst enum ETextureFormat
{
	TEXF_P8,
	TEXF_BGRA8_LM,
	TEXF_R5G6B5,
	TEXF_BC1,
	TEXF_RGB8,
	TEXF_BGRA8,
	TEXF_BC2,
	TEXF_BC3,
	TEXF_BC4,
	TEXF_BC4_S,
	TEXF_BC5,
	TEXF_BC5_S,
	TEXF_BC7,
	TEXF_BC6H_S,
	TEXF_BC6H,
	TEXF_RGBA16,
	TEXF_RGBA16_S,
	TEXF_RGBA32,
	TEXF_RGBA32_S,
	TEXF_NODATA,
	TEXF_UNCOMPRESSED,
	TEXF_UNCOMPRESSED_LOW,
	TEXF_UNCOMPRESSED_HIGH,
	TEXF_COMPRESSED,
	TEXF_COMPRESSED_LOW,
	TEXF_COMPRESSED_HIGH,
	TEXF_BC1_PA,
	TEXF_R8,
	TEXF_R8_S,
	TEXF_R16,
	TEXF_R16_S,
	TEXF_R32,
	TEXF_R32_S,
	TEXF_RG8,
	TEXF_RG8_S,
	TEXF_RG16,
	TEXF_RG16_S,
	TEXF_RG32,
	TEXF_RG32_S,
	TEXF_RGB8_S,
	TEXF_RGB16,
	TEXF_RGB16_S,
	TEXF_RGB32,
	TEXF_RGB32_S,
	TEXF_RGBA8,
	TEXF_RGBA8_S,
	TEXF_R16_F,
	TEXF_R32_F,
	TEXF_RG16_F,
	TEXF_RG32_F,
	TEXF_RGB16_F,
	TEXF_RGB32_F,
	TEXF_RGBA16_F,
	TEXF_RGBA32_F,
	TEXF_ETC1,
	TEXF_ETC2,
	TEXF_ETC2_PA,
	TEXF_ETC2_RGB_EAC_A,
	TEXF_EAC_R,
	TEXF_EAC_R_S,
	TEXF_EAC_RG,
	TEXF_EAC_RG_S,
	TEXF_ASTC_4x4,
	TEXF_ASTC_5x4,
	TEXF_ASTC_5x5,
	TEXF_ASTC_6x5,
	TEXF_ASTC_6x6,
	TEXF_ASTC_8x5,
	TEXF_ASTC_8x6,
	TEXF_ASTC_8x8,
	TEXF_ASTC_10x5,
	TEXF_ASTC_10x6,
	TEXF_ASTC_10x8,
	TEXF_ASTC_10x10,
	TEXF_ASTC_12x10,
	TEXF_ASTC_12x12,
	TEXF_ASTC_3x3x3,
	TEXF_ASTC_4x3x3,
	TEXF_ASTC_4x4x3,
	TEXF_ASTC_4x4x4,
	TEXF_ASTC_5x4x4,
	TEXF_ASTC_5x5x4,
	TEXF_ASTC_5x5x5,
	TEXF_ASTC_6x5x5,
	TEXF_ASTC_6x6x5,
	TEXF_ASTC_6x6x6,
	TEXF_PVRTC1_2BPP,
	TEXF_PVRTC1_4BPP,
	TEXF_PVRTC2_2BPP,
	TEXF_PVRTC2_4BPP,
	TEXF_R8_UI,
	TEXF_R8_I,
	TEXF_R16_UI,
	TEXF_R16_I,
	TEXF_R32_UI,
	TEXF_R32_I,
	TEXF_RG8_UI,
	TEXF_RG8_I,
	TEXF_RG16_UI,
	TEXF_RG16_I,
	TEXF_RG32_UI,
	TEXF_RG32_I,
	TEXF_RGB8_UI,
	TEXF_RGB8_I,
	TEXF_RGB16_UI,
	TEXF_RGB16_I,
	TEXF_RGB32_UI,
	TEXF_RGB32_I,
	TEXF_RGBA8_UI,
	TEXF_RGBA8_I,
	TEXF_RGBA16_UI,
	TEXF_RGBA16_I,
	TEXF_RGBA32_UI,
	TEXF_RGBA32_I,
	TEXF_ARGB8,
	TEXF_ABGR8,
	TEXF_RGB10A2,
	TEXF_RGB10A2_UI,
	TEXF_RGB10A2_LM,
	TEXF_RGB9E5,
	TEXF_P8_RGB9E5,
	TEXF_R1,
} Format;

// Palette.
var(Texture) palette Palette;

// Internal info.
var const byte  UBits, VBits;
var const int   USize, VSize;
var(Texture) const int UClamp, VClamp;
var const color MipZero;
var const color MaxColor;
var const int   InternalTime[2];

defaultproperties
{
      Format=TEXF_P8
      Palette=None
      UBits=0
      VBits=0
      USize=0
      VSize=0
      UClamp=0
      VClamp=0
      MipZero=(R=64,G=128,B=64,A=0)
      MaxColor=(R=255,G=255,B=255,A=255)
      InternalTime(0)=0
      InternalTime(1)=0
}
