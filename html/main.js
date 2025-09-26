$(document).ready(function () {
    $(".container").hide();
    $(".info-box").hide();
    $("#apartment").hide();
    $("#housevip").hide();
    $("#personalhouse").hide();
    $("#firstspawn").hide();

    let current;
    let pos;
    let last_position;

    let aptInfo = null;
    let vipInfo = null;
    let houseInfo = null;

    window.addEventListener("message", function (event) {
        if (event.data.action === "has_apartment") {
            $("#apartment").show();
            aptInfo = event.data.info[0];
        }

        if (event.data.action === "has_vip_house") {
            $("#housevip").show();
            vipInfo = event.data.info[0];
        }

        if (event.data.action === "has_personal_house") {
            $("#personalhouse").show();
            houseInfo = event.data.info[0];
        }

        if (event.data.action === "showfirstspawn") {
            $("#firstspawn").show();
        }

        let data = event.data;

        last_position = data.last;
        // extra_position = data.extra

        $(".container").show();
        createButtons(data.data);
    });

    function createButtons(data) {
        let len = data.length;

        for (let i = 0; i < len; i++) {
            $(".spawn-points").append(
                '<i class="fas fa-map-marker-alt" data-id=' +
                i +
                ' id="loc' +
                i +
                '"><div class="info-box" id="label' +
                i +
                '">' +
                data[i].label +
                "</div></i>"
            );

            $(".spawn-points")
                .find("[data-id=" + i + "]")
                .data("data", data[i]);

            $(".spawn-points")
                .find("[data-id=" + i + "]")
                .data("coords", data[i].coords);

            $(".spawn-points")
                .find("[data-id=" + i + "]")
                .data("id", i
            );
        }
    }

    $(document).on("mouseenter", ".fas", function (e) {
        let th = $(this);

        $("#label" + th.data("id")).fadeIn(150);

        if (th.data("data").label != null) {
            $("#label" + current).fadeOut(150);
        }
    });

    $(document).on("mouseleave", ".fas", function (e) {
        let th = $(this);

        if ("#label" + th.data("id") !== "#label" + current) {
            $("#label" + th.data("id")).fadeOut(150);
        }
    });

    $(document).on("click", ".fas", function (e) {
        let th = $(this);

        if (current !== null) {
            $("#loc" + current).css("color", "rgb(255, 65, 65)");

            $("#loc" + current).css("font-size", "x-large");

            $("#label" + current).fadeOut(400);
        }

        $("#loc" + th.data("id")).css("color", "rgb(253, 253, 253)");

        current = th.data("id");

        pos = th.data("coords");
    });

    $(document).on("click", ".fa-map-marker-alt", function (e) {
        if (pos !== null) {
            $(".container").fadeOut(500);

            $.post(
                "https://kbnrp_spawn/spawn:selection:spawning",
                JSON.stringify({
                    coords: pos,
                    apartment: false,
                    vip: false,
                    house: false,
                    info: null,
                })
            );

            $("#info").hide();
        }
    });

    // last location button

    $(document).on("click", ".lastspawn", function (e) {
        $(".container").fadeOut(500);

        $.post(
            "https://kbnrp_spawn/spawn:selection:last:location",
            JSON.stringify({
                coords: last_position,
                apartment: false,
                vip: false,
                house: false,
                firstspawn: true,
                info: null,
            })
        );

        $("#info").hide();
    });

    //apartment button

    $(document).on("click", ".apartment", function (e) {
        $(".container").fadeOut(500);

        $.post(
            "https://kbnrp_spawn/spawn:selection:spawning",
            JSON.stringify({
                coords: aptInfo.location,
                apartment: true,
                vip: false,
                house: false,
                firstspawn: false,
                info: aptInfo,
            })
        );

        $("#info").hide();
    });

    //vip house button

    $(document).on("click", ".housevip", function (e) {
        $(".container").fadeOut(500);

        $.post(
            "https://kbnrp_spawn/spawn:selection:spawning",
            JSON.stringify({
                coords: vipInfo.location,
                apartment: false,
                vip: true,
                house: false,
                firstspawn: false,
                info: vipInfo,
            })
        );

        $("#info").hide();
    });

    //personal house button

    $(document).on("click", ".personalhouse", function (e) {
        $(".container").fadeOut(500);

        $.post(
        "https://kbnrp_spawn/spawn:selection:spawning",
            JSON.stringify({
                coords: houseInfo.location,
                apartment: false,
                vip: false,
                house: true,
                firstspawn: false,
                info: houseInfo,
            })
        );

        $("#info").hide();
    });
});
