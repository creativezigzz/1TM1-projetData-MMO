var box = document.getElementById("liste");
var ourRequest = new XMLHttpRequest();

function initListe(){
ourRequest.open('GET', 'http://localhost/getAnimeList');
ourRequest.onload = function (){
	var ourData = JSON.parse(ourRequest.responseText);
	renderHTML(ourData);
};
ourRequest.send();
}
function renderHTML(data){
	var str = "";
	var cols = Object.keys(data[0]);
	var table = "<table>";
	var titre = "<tr>";
	for(var i in cols){
	titre += "<th>" + cols[i] + "</th>"
  }
  titre += "</tr>";

	var liste = "";
	for(var i in data){
	liste += "<tr>";
	liste += "<td>" + data[i].animeNom + "</td>";
	liste += "<td>" + data[i].note + "</td>";
	liste += "</tr>";
  }
	
  var table = "<table>" + titre + liste + "</table>";
  document.getElementById("liste").innerHTML = table;
  console.log(cols);
}