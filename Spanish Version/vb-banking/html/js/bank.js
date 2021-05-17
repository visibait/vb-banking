$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "openGeneral"){
            $('body').fadeIn(500);
        } else if(event.data.type === "balanceHUD") {
            var balance = event.data.balance;
            $('.vb-banking-creditcard-footer-cardholder').html(event.data.player);
            $('.vb-balance-balance').html("$ "+balance);
            $('.vb-banking-tarjetas-mycardcontainer-balance').html("$ "+balance);
            $('.vb-banking-tarjetas-rigthbar-balance').html("$ "+balance);
            $('.vb-banking-myaccount-balance-balance').html("$ "+balance);
            $('.vb-banking-myaccount-faq-balance').html("$ "+balance);
            if (balance.toString().length >= Number(6)) {
                document.getElementById("vb-banking-tarjetas-mycardcontainer-balance").style.fontSize = "28px"
                document.getElementById("vb-banking-tarjetas-rigthbar-balance").style.fontSize = "25px"
                document.getElementById("vb-banking-depositcontainer-balance").style.fontSize = "25px"
                document.getElementById("vb-banking-transferir-container-balance").style.fontSize = "25px"
                document.getElementById("vb-banking-transferir-myaccount-balance").style.fontSize = "25px"
            }
            var playername = event.data.player
            $('.vb-banking-creditcard-cardholder').html(playername);
            var address = event.data.address
            $('.vb-banking-myaccount-info-address').html('<i class="fal fa-map-marker-alt"></i>&nbsp;&nbsp;&nbsp;</i>Dirección:&nbsp;&nbsp;'+address+'</span>');
            var walletid = event.data.playerid
            $('.vb-banking-myaccount-info-walletid').html('<i class="fal fa-wallet"></i>&nbsp;&nbsp;&nbsp;</i>Wallet ID:&nbsp;&nbsp;'+walletid+'</span>');
        } else if (event.data.type === "closeAll"){
            $('body').fadeOut(500);
        }
    });
});

$(document).on('click','#inicio',function(){
    hideall();
    $(".vb-banking-container-inicio").fadeIn(500);
})

$(document).on('click','#mycards',function(){
    hideall();
    $(".vb-banking-bigcontainertarjetas").fadeIn(500);
})

$(document).on('click','#meterpastica',function(){
    hideall();
    $(".vb-banking-bigcontainerdepositar").fadeIn(500);
})

$(document).on('click','#depositar',function(){
    hideall();
    $(".vb-banking-bigcontainerdepositar").fadeIn(500);
})

$(document).on('click','#transfer',function(){
    hideall();
    $(".vb-banking-bigcontainertransfer").fadeIn(500);
})

$(document).on('click','#myaccount',function(){
    hideall();
    $(".vb-banking-bigcontainermyaccount").fadeIn(500);
})

$(document).on('click','#faq',function(){
    hideall();
    $(".vb-banking-bigcontainerfaq").fadeIn(500);
})

$(document).on('click','#closebanking',function(){
    $('body').fadeOut(500);
    $.post('http://vb-banking/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#withdraw',function(e){
    e.preventDefault();
    $.post('http://vb-banking/withdraw', JSON.stringify({
        amountw: $("#withdrawnumber").val()
    }));
    $('body').fadeOut(500);
    $.post('http://vb-banking/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#depositarpasta',function(e){
    e.preventDefault();
    $.post('http://vb-banking/deposit', JSON.stringify({
        amount: $("#cantidaddepositar").val()
    }));
    $('body').fadeOut(500);
    $.post('http://vb-banking/NUIFocusOff', JSON.stringify({}));
})

$(document).on('click','#transferirpasta',function(e){
    e.preventDefault();
    $.post('http://vb-banking/transfer', JSON.stringify({
        to: $("#iddestinatario").val(),
        amountt: $("#cantidadtransfer").val()
    }));
    $('body').fadeOut(500);
    $.post('http://vb-banking/NUIFocusOff', JSON.stringify({}));
})

function hideall() {
    $(".vb-banking-container-inicio").hide();
    $(".vb-banking-bigcontainertarjetas").hide();
    $(".vb-banking-bigcontainerdepositar").hide();
    $(".vb-banking-bigcontainertransfer").hide();
    $(".vb-banking-bigcontainermyaccount").hide();
    $(".vb-banking-bigcontainerfaq").hide();
}

document.onkeyup = function(data){
    if (data.which == 27){
        $('body').fadeOut(500);
        $.post('http://vb-banking/NUIFocusOff', JSON.stringify({}));
    }
}