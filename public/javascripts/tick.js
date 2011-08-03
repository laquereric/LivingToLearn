  var tick_targets = new Array();

  function deliver_ticks() {
    for ( var i=0 ; i < tick_targets.length;i++){
      tick_targets[i].tick();
    }
  }

  function tick() {
    deliver_ticks();
    var t = setTimeout("tick()",1000);
  }


