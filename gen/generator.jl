using Clang.Generators

arch = lowercase(String(Sys.ARCH))
kernel = lowercase(String(Sys.KERNEL))

if kernel == "darwin"
	kernel = "macos"
end

releasefile = "wgpu-$kernel-$arch-release.zip"
location = "$releasefile"

upstreamVersion = "v0.19.4.1"

url = "https://github.com/gfx-rs/wgpu-native/releases/download/$(upstreamVersion)/wgpu-$kernel-$arch-release.zip"
download(url, location)
run(`rm -rf wgpulib`)
run(`mkdir wgpulib`)
run(`unzip $location -d wgpulib`)
run(`rm $releasefile`)

const C_HEADERS = ["wgpu.h",]
const WGPU_HEADERS = [joinpath(@__DIR__, "wgpulib", h) for h in C_HEADERS]

options = load_options(joinpath(@__DIR__, "generator.toml"))

args = get_default_args()

ctx = create_context(WGPU_HEADERS, args, options)

build!(ctx)

run(`rm -rf wgpulib`)


