package cgltf

import _c "core:c"
import "core:os"

when os.OS == "windows" {
	foreign import "lib/cgltf.lib"
}

@(default_calling_convention="c")
foreign cgltf {

    @(link_name="cgltf_parse")
    parse :: proc(
        options : ^Options,
        data : rawptr,
        size : uint,
        out_data : ^^Data
    ) -> Result ---;

    @(link_name="cgltf_parse_file")
    parse_file :: proc(
        options : ^Options,
        path : cstring,
        out_data : ^^Data
    ) -> Result ---;

    @(link_name="cgltf_load_buffers")
    load_buffers :: proc(
        options : ^Options,
        data : ^Data,
        gltf_path : cstring
    ) -> Result ---;

    @(link_name="cgltf_load_buffer_base64")
    load_buffer_base64 :: proc(
        options : ^Options,
        size : uint,
        base64 : cstring,
        out_data : ^rawptr
    ) -> Result ---;

    @(link_name="cgltf_decode_uri")
    decode_uri :: proc(uri : cstring) ---;

    @(link_name="cgltf_validate")
    validate :: proc(data : ^Data) -> Result ---;

    @(link_name="cgltf_free")
    free :: proc(data : ^Data) ---;

    @(link_name="cgltf_node_transform_local")
    node_transform_local :: proc(
        node : ^Node,
        out_matrix : ^_c.float
    ) ---;

    @(link_name="cgltf_node_transform_world")
    node_transform_world :: proc(
        node : ^Node,
        out_matrix : ^_c.float
    ) ---;

    @(link_name="cgltf_accessor_read_float")
    accessor_read_float :: proc(
        accessor : ^Accessor,
        index : uint,
        out : ^_c.float,
        element_size : uint
    ) -> _c.int ---;

    @(link_name="cgltf_accessor_read_uint")
    accessor_read_uint :: proc(
        accessor : ^Accessor,
        index : uint,
        out : ^_c.uint,
        element_size : uint
    ) -> _c.int ---;

    @(link_name="cgltf_accessor_read_index")
    accessor_read_index :: proc(
        accessor : ^Accessor,
        index : uint
    ) -> uint ---;

    @(link_name="cgltf_num_components")
    num_components :: proc(type : Type) -> uint ---;

    @(link_name="cgltf_accessor_unpack_floats")
    accessor_unpack_floats :: proc(
        accessor : ^Accessor,
        out : ^_c.float,
        float_count : uint
    ) -> uint ---;

    @(link_name="cgltf_copy_extras_json")
    copy_extras_json :: proc(
        data : ^Data,
        extras : ^Extras,
        dest : cstring,
        dest_size : ^uint
    ) -> Result ---;

}

File_Type :: enum i32 {
    Invalid,
    Gltf,
    Glb,
};

Result :: enum i32 {
    Success,
    Data_too_short,
    Unknown_format,
    Invalid_json,
    Invalid_gltf,
    Invalid_options,
    File_not_found,
    Io_error,
    Out_of_memory,
    Legacy_gltf,
};

Buffer_View_Type :: enum i32 {
    Invalid,
    Indices,
    Vertices,
};

Attribute_Type :: enum i32 {
    Invalid,
    Position,
    Normal,
    Tangent,
    Texcoord,
    Color,
    Joints,
    Weights,
};

Component_Type :: enum i32 {
    Invalid,
    R_8,
    R_8u,
    R_16,
    R_16u,
    R_32u,
    R_32f,
};

Type :: enum i32 {
    Invalid,
    Scalar,
    Vec2,
    Vec3,
    Vec4,
    Mat2,
    Mat3,
    Mat4,
};

Primitive_Type :: enum i32 {
    Points,
    Lines,
    Line_loop,
    Line_strip,
    Triangles,
    Triangle_Strip,
    Triangle_Fan,
};

Alpha_Mode :: enum i32 {
    Opaque,
    Mask,
    Blend,
};

Animation_Path_Type :: enum i32 {
    Invalid,
    Translation,
    Rotation,
    Scale,
    Weights,
};

Interpolation_Type :: enum i32 {
    Linear,
    Step,
    Cubic_spline,
};

Camera_Type :: enum i32 {
    Invalid,
    Perspective,
    Orthographic,
};

Light_Type :: enum i32 {
    Invalid,
    Directional,
    Point,
    Spot,
};

Memory_Options :: struct {
	alloc : #type proc "c" (user : rawptr, size : uint) -> rawptr,
    free : #type proc "c" (user : rawptr, ptr : rawptr),
    user_data : rawptr,
};

File_Options :: struct {
	read : #type proc "c" (memory_options : Memory_Options, file_options : File_Options, path : cstring, size : uint, data : ^rawptr) -> Result,
    release : #type proc "c" (memory_options : Memory_Options, file_options : File_Options , data : rawptr),
    user_data : rawptr,
};

Options :: struct {
    type : File_Type,
    json_token_count : uint,
    memory : Memory_Options,
    file : File_Options,
};

Extras :: struct {
    start_offset : uint,
    end_offset : uint,
};

Extension :: struct {
    name : cstring,
    data : cstring,
};

Buffer :: struct {
    size : uint,
    uri : cstring,
    data : rawptr,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Buffer_View :: struct {
    buffer : ^Buffer,
    offset : uint,
    size : uint,
    stride : uint,
    type : Buffer_View_Type,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Accessor_Sparse :: struct {
    count : uint,
    indices_buffer_view : ^Buffer_View,
    indices_byte_offset : uint,
    indices_component_type : Component_Type,
    values_buffer_view : ^Buffer_View,
    values_byte_offset : uint,
    extras : Extras,
    indices_extras : Extras,
    values_extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
    indices_extensions_count : uint,
    indices_extensions : ^Extension,
    values_extensions_count : uint,
    values_extensions : ^Extension,
};

Accessor :: struct {
    component_type : Component_Type,
    normalized : _c.int,
    type : Type,
    offset : uint,
    count : uint,
    stride : uint,
    buffer_view : ^Buffer_View,
    has_min : _c.int,
    min : [16]_c.float,
    has_max : _c.int,
    max : [16]_c.float,
    is_sparse : _c.int,
    sparse : Accessor_Sparse,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Attribute :: struct {
    name : cstring,
    type : Attribute_Type,
    index : _c.int,
    data : ^Accessor,
};

Image :: struct {
    name : cstring,
    uri : cstring,
    buffer_view : ^Buffer_View,
    mime_type : cstring,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Sampler :: struct {
    mag_filter : _c.int,
    min_filter : _c.int,
    wrap_s : _c.int,
    wrap_t : _c.int,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Texture :: struct {
    name : cstring,
    image : ^Image,
    sampler : ^Sampler,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Texture_Transform :: struct {
    offset : [2]_c.float,
    rotation : _c.float,
    scale : [2]_c.float,
    texcoord : _c.int,
};

Texture_View :: struct {
    texture : ^Texture,
    texcoord : _c.int,
    scale : _c.float,
    has_transform : _c.int,
    transform : Texture_Transform,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Pbr_Metallic_Roughness :: struct {
    base_color_texture : Texture_View,
    metallic_roughness_texture : Texture_View,
    base_color_factor : [4]_c.float,
    metallic_factor : _c.float,
    roughness_factor : _c.float,
    extras : Extras,
};

Pbr_Specular_Glossiness :: struct {
    diffuse_texture : Texture_View,
    specular_glossiness_texture : Texture_View,
    diffuse_factor : [4]_c.float,
    specular_factor : [3]_c.float,
    glossiness_factor : _c.float,
};

Clearcoat :: struct {
    clearcoat_texture : Texture_View,
    clearcoat_roughness_texture : Texture_View,
    clearcoat_normal_texture : Texture_View,
    clearcoat_factor : _c.float,
    clearcoat_roughness_factor : _c.float,
};

Transmission :: struct {
    transmission_texture : Texture_View,
    transmission_factor : _c.float,
};

Ior :: struct {
    ior : _c.float,
};

Material :: struct {
    name : cstring,
    has_pbr_metallic_roughness : _c.int,
    has_pbr_specular_glossiness : _c.int,
    has_clearcoat : _c.int,
    has_transmission : _c.int,
    has_ior : _c.int,
    pbr_metallic_roughness : Pbr_Metallic_Roughness,
    pbr_specular_glossiness : Pbr_Specular_Glossiness,
    clearcoat : Clearcoat,
    ior : Ior,
    transmission : Transmission,
    normal_texture : Texture_View,
    occlusion_texture : Texture_View,
    emissive_texture : Texture_View,
    emissive_factor : [3]_c.float,
    alpha_mode : Alpha_Mode,
    alpha_cutoff : _c.float,
    double_sided : _c.int,
    unlit : _c.int,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Morph_Target :: struct {
    attributes : ^Attribute,
    attributes_count : uint,
};

Draco_Mesh_Compression :: struct {
    buffer_view : ^Buffer_View,
    attributes : ^Attribute,
    attributes_count : uint,
};

Primitive :: struct {
    type : Primitive_Type,
    indices : ^Accessor,
    material : ^Material,
    attributes : ^Attribute,
    attributes_count : uint,
    targets : ^Morph_Target,
    targets_count : uint,
    extras : Extras,
    has_draco_mesh_compression : _c.int,
    draco_mesh_compression : Draco_Mesh_Compression,
    extensions_count : uint,
    extensions : ^Extension,
};

Mesh :: struct {
    name : cstring,
    primitives : ^Primitive,
    primitives_count : uint,
    weights : ^_c.float,
    weights_count : uint,
    target_names : ^cstring,
    target_names_count : uint,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Node :: struct {
    name : cstring,
    parent : ^Node,
    children : ^^Node,
    children_count : uint,
    skin : ^Skin,
    mesh : ^Mesh,
    camera : ^Camera,
    light : ^Light,
    weights : ^_c.float,
    weights_count : uint,
    has_translation : _c.int,
    has_rotation : _c.int,
    has_scale : _c.int,
    has_matrix : _c.int,
    translation : [3]_c.float,
    rotation : [4]_c.float,
    scale : [3]_c.float,
    matrix : [16]_c.float,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Skin :: struct {
    name : cstring,
    joints : ^^Node,
    joints_count : uint,
    skeleton : ^Node,
    inverse_bind_matrices : ^Accessor,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Camera_Perspective :: struct {
    aspect_ratio : _c.float,
    yfov : _c.float,
    zfar : _c.float,
    znear : _c.float,
    extras : Extras,
};

Camera_Orthographic :: struct {
    xmag : _c.float,
    ymag : _c.float,
    zfar : _c.float,
    znear : _c.float,
    extras : Extras,
};

Camera :: struct {
    name : cstring,
    type : Camera_Type,
    data : AnonymousUnion0,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Light :: struct {
    name : cstring,
    color : [3]_c.float,
    intensity : _c.float,
    type : Light_Type,
    range : _c.float,
    spot_inner_cone_angle : _c.float,
    spot_outer_cone_angle : _c.float,
};

Scene :: struct {
    name : cstring,
    nodes : ^^Node,
    nodes_count : uint,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Animation_Sampler :: struct {
    input : ^Accessor,
    output : ^Accessor,
    interpolation : Interpolation_Type,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Animation_Channel :: struct {
    sampler : ^Animation_Sampler,
    target_node : ^Node,
    target_path : Animation_Path_Type,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Animation :: struct {
    name : cstring,
    samplers : ^Animation_Sampler,
    samplers_count : uint,
    channels : ^Animation_Channel,
    channels_count : uint,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Asset :: struct {
    copyright : cstring,
    generator : cstring,
    version : cstring,
    min_version : cstring,
    extras : Extras,
    extensions_count : uint,
    extensions : ^Extension,
};

Data :: struct {
    file_type : File_Type,
    file_data : rawptr,
    asset : Asset,
    meshes : ^Mesh,
    meshes_count : uint,
    materials : ^Material,
    materials_count : uint,
    accessors : ^Accessor,
    accessors_count : uint,
    buffer_views : ^Buffer_View,
    buffer_views_count : uint,
    buffers : ^Buffer,
    buffers_count : uint,
    images : ^Image,
    images_count : uint,
    textures : ^Texture,
    textures_count : uint,
    samplers : ^Sampler,
    samplers_count : uint,
    skins : ^Skin,
    skins_count : uint,
    cameras : ^Camera,
    cameras_count : uint,
    lights : ^Light,
    lights_count : uint,
    nodes : ^Node,
    nodes_count : uint,
    scenes : ^Scene,
    scenes_count : uint,
    scene : ^Scene,
    animations : ^Animation,
    animations_count : uint,
    extras : Extras,
    data_extensions_count : uint,
    data_extensions : ^Extension,
    extensions_used : ^cstring,
    extensions_used_count : uint,
    extensions_required : ^cstring,
    extensions_required_count : uint,
    json : cstring,
    json_size : uint,
    bin : rawptr,
    bin_size : uint,
    memory : Memory_Options,
    file : File_Options,
};

AnonymousUnion0 :: struct #raw_union {
    perspective : Camera_Perspective,
    orthographic : Camera_Orthographic,
};

