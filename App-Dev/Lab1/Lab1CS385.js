const element = [
    { ElementName: "Hydrogen", Density: 0.09, MeltingPoint: -259, BoilingPoint: -253 },
    { ElementName: "Carbon", Density: 2.26, MeltingPoint: 3500, BoilingPoint: 4827 },
    { ElementName: "Mercury", Density: 13.55, MeltingPoint: -39, BoilingPoint: 357 },
    { ElementName: "Tungsten", Density: 19.32, MeltingPoint: 3410, BoilingPoint: 5660 },
    { ElementName: "Uranium", Density: 18.95, MeltingPoint: 1132, BoilingPoint: 3827 },
    { ElementName: "Gold", Density: 19.32, MeltingPoint: 1064, BoilingPoint: 2807 },
    { ElementName: "Helium", Density: 0.18, MeltingPoint: -272, BoilingPoint: -269 },
    { ElementName: "Bromine", Density: 3.12, MeltingPoint: -7, BoilingPoint: 59 },
    { ElementName: "Uranium", Density: 1.43, MeltingPoint: -218, BoilingPoint: -173 },
];

console.log(element);


let totalBoiling = element.reduce(addBoiling, 0);
console.log(totalBoiling);

function addBoiling(total, current) {
    return total + current.Density;
}

const filterElement = element.filter(filterBoiling);
console.log(filterElement);

function filterBoiling(tObject) {
    return tObject.BoilingPoint < 0;
}


const filterElement2 = element.filter(meltBoil);
console.log(filterElement2);

function meltBoil(tObject) {
    
        return ((tObject.MeltingPoint >= 1000) && (tObject.BoilingPoint >= 1000));
    
}


const updateElement = element.map(increaseCelBoil);
console.log(updateElement);

function increaseCelBoil(tObject3){
    tObject3.BoilingPoint = tObject3.BoilingPoint + 7;
    return tObject3;
}


let totalDesity2 = element.filter(filter5).reduce(addBoiling,0);
console.log(totalDesity2);
const filterDen = element.filter(filter5);
function filter5(tObject){
    return tObject.Density < 5;
}


// DO SORT DUNCTION NEXT

function compareElementName(elX, elY){

    let nameX = elX.ElementName.toUpperCase();
    let nameY = elY.ElementName.toUpperCase();

    if(nameX < nameY){
        return -1;
    }
    if(nameY < nameX){
        return 1;
    }

    return 0;
}
element.sort(compareElementName);
console.log(element);