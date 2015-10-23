@compat function scatterplot(;x::AbstractVector = Int[],
                      y::AbstractVector = Int[],
                      group::AbstractVector = Int[],
                      pointShape::AbstractString = "circle",
                      pointSize::Real = 50)
    v = VegaVisualization()

    default_scales!(v)
    default_axes!(v)

    #if non-null array for group, add legend

    if group != Int[]
        default_legend!(v)
    end

    add_data!(v, x = x, y = y, group = group)
    add_points!(v)

    v.marks[1].properties.enter.fill = VegaValueRef(scale = "group", field = "group")
    v.marks[1].properties.enter.fillOpacity = VegaValueRef(value = 0.9)
    v.marks[1].properties.enter.size = VegaValueRef(value = pointSize)
    v.marks[1].properties.enter.shape = VegaValueRef(value = pointShape)

    #Default to Paired color scale, 12
    colorscheme!(v; palette = ("Paired", 12))
    return v
end
