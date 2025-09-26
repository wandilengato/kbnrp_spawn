$(document).ready(function(){

    $(".container").hide();

    $(".info-box").hide();

    $("#apartment").hide();

    $("#housevip").hide();

    $("#personalhouse").hide();

    var current

    var pos

    var lastpos



    var aptInfo

    var houseVipInfo

    var house_data



    window.addEventListener("message", function(event){

        if (event.data.action === "showApartment"){

            $("#apartment").show();

            aptInfo = event.data.info

        }

        if (event.data.action === "showHouseVIP"){

            $("#housevip").show();

            houseVipInfo = event.data.info

        }



        if (event.data.action === "showHousesPersonal"){

            $("#personalhouse").show();

            house_data = event.data.info

        }



        var data = event.data

        lastpos = data.lastpos

        extrapos = data.extralocation

        if(extrapos === true){

            $('#loc2').hide()

            $('#loc3').hide()

            $('#loc4').hide()

            $('#loc5').hide()

        }

        $(".container").show()

        createButtons(data.data)

    });





    // Function

    function createButtons(data) { 

        var len = data.length

        for (i=0; i < len; i++) {

            $(".spawn-points").append('<i class="fas fa-map-marker-alt" data-id=' + i + ' id="loc' + i + '"><div class="info-box" id="label' + i +'">' + data[i].label + '</div></i>');

            $(".spawn-points").find("[data-id="+i+"]").data("data", data[i]);

            $(".spawn-points").find("[data-id="+i+"]").data("coords", data[i].coords);

            $(".spawn-points").find("[data-id="+i+"]").data("id", i);

        }

    }







    // İconlar

    $(document).on("mouseenter", ".fas", function(e){

        var th = $(this)

        $("#label"+th.data("id")).fadeIn(150);

        if (th.data("data").label != null) {

            $("#label"+current).fadeOut(150);

        }

    });



    $(document).on("mouseleave", ".fas", function(e){

        var th = $(this)

        if ("#label" + th.data("id") != "#label"+current) {

            $("#label"+th.data("id")).fadeOut(150);

        }

    });



    $(document).on("click", ".fas", function(e){

        var th = $(this)

        if (current != null) {

            $("#loc"+current).css("color", "rgb(255, 65, 65)");

            $("#loc"+current).css("font-size", "x-large");

            $("#label"+current).fadeOut(400);

        }

       $("#loc"+th.data("id")).css("color", "rgb(253, 253, 253)");

       current = th.data("id")

       pos = th.data("coords")

    });







    // Butonlar

    $(document).on("click", ".fa-map-marker-alt", function(e){

        if (pos != null) {

            $(".container").fadeOut(500)

            $.post('https://kbnrp_spawn/spawn', JSON.stringify({coords: pos, apartment : false, housevip : false, personalhouse:false, info : null}));

            $('#info').hide()

        }

    });



    $(document).on("click", ".lastspawn", function(e){

        $(".container").fadeOut(500)

        $.post('https://kbnrp_spawn/laslocation', JSON.stringify({coords: lastpos, apartment : false, housevip : false, personalhouse: false, info : null}));

         $('#info').hide()

    });



    $(document).on("click", ".apartment", function(e){

        $(".container").fadeOut(500)

        $.post('https://kbnrp_spawn/spawn', JSON.stringify({ coords : aptInfo.location, apartment : true, housevip : false, personalhouse: false, info : aptInfo}));

        $('#info').hide()

    });

    $(document).on("click", ".housevip", function(e){

        $(".container").fadeOut(500)

        $.post('https://kbnrp_spawn/spawn', JSON.stringify({ coords : houseVipInfo.location, apartment : false, housevip : true, personalhouse : false, info : houseVipInfo}));

        $('#info').hide()

    });



    $(document).on("click", ".personalhouse", function(e){

        $(".container").fadeOut(500)

        $.post('https://kbnrp_spawn/spawn', JSON.stringify({ coords : house_data.location, apartment : false, housevip : false, personalhouse : true, info : house_data}));

        $('#info').hide()

    });

})