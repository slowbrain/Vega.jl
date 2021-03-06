@compat function groupedbar(; x::AbstractArray = Int[], y::AbstractArray = Int[], position::Vector{Int} = Int[], horizontal::Bool = false)

    v = VegaVisualization(height = 300, width = 500, name = "groupedbar")

    #This seems like it should be a method, but so easy to do right here
    if typeof(x) == Vector{Char}
        x = UTF8String[string(s) for s in x]
    end

    add_data!(v, x = x, y = y, group = position)
    default_axes!(v)
    default_legend!(v)

    v.scales = Array(VegaScale, 3)

    v.scales[1] = VegaScale(name = "x",
                            _type = "ordinal",
                            range = "width",
                            padding = 0.2,
                            domain = VegaDataRef("table", "x"))
    v.scales[2] = VegaScale(name = "y",
                            range = "height",
                            domain = VegaDataRef("table", "y"),
                            nice = true)
    v.scales[3] = VegaScale(name = "group",
                            _type = "ordinal",
                            range = "category20",
                            domain = VegaDataRef("table", "group"))

    v.marks = [VegaMark(_type = "group")]
    v.marks[1].from = VegaMarkFrom(data = "table",
                                   transform = [VegaTransform(Dict{Any, Any}("groupby" => ["x"], "type" => "facet"))])

    v.marks[1].marks = [VegaMark(_type = "rect")]
    v.marks[1].marks[1].properties = VegaMarkProperties(enter = VegaMarkPropertySet(fill = VegaValueRef(field = "group", scale = "group"),
                                                                                    width = VegaValueRef(band = true, offset = -1, scale = "pos"),
                                                                                    x = VegaValueRef(field = "group", scale = "pos"),
                                                                                    y = VegaValueRef(field = "y", scale = "y"),
                                                                                    y2 = VegaValueRef(scale = "y", value = 0)
                                                                                    )
                                                        )
    v.marks[1].properties = VegaMarkProperties(enter = VegaMarkPropertySet(width = VegaValueRef(band = true, scale = "x"),
                                                                            x = VegaValueRef(field = "key", scale = "x")
                                                )
                                                )

    v.marks[1].scales = [VegaScale(name = "pos",
                                    _type = "ordinal",
                                    range = "width",
                                    domain = VegaDataRef(field = "group"))]

    #Default to Paired color scale, 12
    colorscheme!(v; palette = ("Paired", 12))

    if horizontal == true
        coord_flip!(v)
    end

    return v

end