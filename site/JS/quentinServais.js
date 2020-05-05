var box = document.getElementById("liste");

function initListe(){
var ourRequest = new XMLHttpRequest();
ourRequest.open('GET', '/getAnimeList?token=' + getCookie("token"));
ourRequest.onload = function (){
	var ourData = JSON.parse(ourRequest.responseText);
	renderHTML(ourData);
};
ourRequest.send();
}


function renderHTML(data){
	var cols = Object.keys(data[0]);
	var titre = "<tr>";
	for(var i in cols){
	titre += "<th>" + cols[i] + "</th>";
  }
  titre += "</tr>";

	var liste = "";
	for(var i in data){
	liste += "<tr>";
	liste += "<td>" + data[i].animeNom + "</td>";
	liste += "<td>" + data[i].genrNom + "</td>";
	liste += "<td>" + data[i].note + "</td>";
	liste += "</tr>"
  }
	
  var table = "<table>" + titre + liste + "</table>";	
  box.innerHTML = table;
}