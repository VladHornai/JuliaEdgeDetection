using Stipple
using StippleUI
using Genie.Requests, Genie.Renderer
using Images, Colors, FileIO, Plots;
Genie.config.cors_headers["Access-Control-Allow-Origin"] = "*"
Genie.config.cors_headers["Access-Control-Allow-Headers"] = "Content-Type"
Genie.config.cors_headers["Access-Control-Allow-Methods"] = "GET,POST,PUT,DELETE,OPTIONS"
Genie.config.cors_allowed_origins = ["*"]

const FILE_PATH = "img/newimages"

# CardDemo definition inheriting from ReactiveModel
# Base.@kwdef: that defines keyword based contructor of mutable struct
Base.@kwdef mutable struct CardDemo <: ReactiveModel
    process::R{Bool} = false
end

# passing CardDemo object(contruction) for 2-way integration between Julia and JavaScript
# returns {ReactiveModel}
hs_model = Stipple.init(CardDemo())

on(hs_model.process) do _
    img =  @info filename(filespayload(:img))
    img_gray = Gray.(img)
    sobel_image = convert(Array{Float64}, img_gray)
    kernel_x = Array{Float64}([1 0 -1; 2 0 -2; 1 0 -1])
    kernel_y = Array{Float64}([1 2 1; 0 0 0; -1 -2 -1])

    function sobel(img)
        edge_img = zeros(Gray{Float64}, size(img, 1), size(img, 2))
        for x = 1:size(edge_img, 1)-size(kernel_x, 1)
            for y = 1:size(edge_img, 2)-size(kernel_y, 2)
                gx = sum(
                    Gray{
                        Float64,
                    }.(@view img[x:x+size(kernel_x, 1)-1, y:y+size(kernel_y, 2)-1]) .*
                    kernel_x,
                )
                gy = sum(
                    Gray{
                        Float64,
                    }.(@view img[x:x+size(kernel_x, 1)-1, y:y+size(kernel_y, 2)-1]) .*
                    kernel_y,
                )
                edge_img[x+1, y+1] = hypot(gx, gy)
            end
        end
        return edge_img
    end
end


function ui()
    [
        page( # page generates HTML code for Single Page Application 
            vm(hs_model),
            class = "container",
            title = "Card Demo",
            partial = true,
            [
                row( # row takes a tuple of cells. Creates a `div` HTML element with a CSS class named `row`.
                    cell([h1("Card Component example")]),
                )
                row(
                    [
                        cell([
                            h2("Initial Image"),
                            card(
                                class = "text-primary d-flex justify-content-start",
                                Html.div(
                                    class = "col-md-12",
                                    [
                                        uploader(
                                            label = "Upload Image",
                                            :auto__upload,
                                            :multiple,
                                            method = "POST",
                                            url = "http://localhost:8000/upload",
                                            field__name = "img",
                                        ),
                                    ],
                                ),
                            ),
                            btn("Process Image!", @click("process = true")),
                        ])
                        cell([
                            h2("Transformed Image"),
                            card(
                                class = "text-primary d-flex justify-content-end",
                                Html.div(class = "col-md-12"),
                            ),
                        ])
                    ],
                )
            ],
        ),
    ]
end

route("/", ui)

route("/upload", method = POST) do
    if infilespayload(:img)
        @info filename(filespayload(:img))
        @info filespayload(:img).data

        open(FILE_PATH, "w") do io
            write(FILE_PATH, filespayload(:img).data)
        end
    else
        @info "No image uploaded"
    end

    Genie.Renderer.redirect(:get)
end

up(open_browser = true)
