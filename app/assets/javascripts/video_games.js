// Place all the behaviors and hooks related to the matching controller here.
// All this logic will automatically be available in application.js.

function setRating() {
  $inputValue = $("#video_game_rating").val();
  $label = $("#video_game_rating").siblings("label");
  $label.text("(0 worst - 5 best) Rating: " + $inputValue);
}

function sendSearch() {

  $inputValue = $("#video_game_search").val();
  $.ajax({
    type: "GET",
    dataType: "json",
    url: `/api/v1/search${window.location.pathname}`,
    data: {'search': $inputValue},
    success: function(data) {
      $games = data.video_games;
      if ($games.length === 0) {
        $(".notice").text(data.notice);
      }else {
        $(".notice").text("")
      }
      $("#video_game_list").html("");
      for (i=0; i < $games.length; i++) {
        $("#video_game_list").append(`<li><a href="/video_games/${$games[i]['id']}">${$games[i]['title']}</a></li>`);
      }
    },
    error: function(data) {
      console.log("Server Request failed");
    }
  })

}

$(document).ready(function() {
  setRating();
  $("#video_game_rating").on("mousemove keyup", setRating);
  $("#video_game_search_button").on("click", function(event) {
    event.preventDefault();
    sendSearch();
  });
  $("#video_game_reset_button").on("click", function(event) {
    event.preventDefault();
    $("#video_game_search").val("")
    sendSearch();

  })
})
