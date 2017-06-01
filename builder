module.exports = function () {
    for (var name in Game.rooms) {

        //переделать на поиск по памяти
        var current_builders = Game.rooms[name].find(FIND_MY_CREEPS, {
            filter: function (creep) {
                return creep.memory.r == 'b';
            }
        });
        //переквалифицируем раобчих если нет добытчиков
        var current_number_of_harvesters = Game.rooms[name].find(FIND_MY_CREEPS, {
            filter: function (creep) {
                return creep.memory.r == 'a';
            }
        }).length;
        if (current_number_of_harvesters == 0 && current_builders.length != 0) {
            for (var creep in current_builders) {
                var sources = Game.rooms[name].find(FIND_SOURCES);
                sources.sort(_custom_source_sort_by_road_and_work_places);

                for (var source in sources) {
                    if (Memory.res[sources[source].id].e <= 0 || Memory.res[sources[source].id].d == 1)continue;

                    Memory.res[sources[source].id].e = Memory.res[sources[source].id].e - 1;
                    current_builders[creep].memory.res = sources[source].id;
                    current_builders[creep].moveTo(sources[source]);
                    current_builders[creep].harvest(sources[source]);
                    break;
                }
                current_builders[creep].r = "a";
            }
            continue;
        }
///////////////////////////////////
        var construction_sites = Game.rooms[name].find(FIND_CONSTRUCTION_SITES);
        var site_to_build = {};

        if (construction_sites.length) {
            for (var structure_to_build in construction_sites) {
                site_to_build = construction_sites[structure_to_build];
                break;
            }
            for (var creep in current_builders) {
                if (current_builders[creep].carry.energy != 0) {
                    current_builders[creep].moveTo(site_to_build);
                    current_builders[creep].build(site_to_build);
                }else{
                    var closest_object_of_energy = current_builders[creep].pos.findClosest(FIND_MY_STRUCTURES, {
                        filter: function (structure) {
                            return  structure.structureType == 'storage' ;
                        }
                    });
                    current_builders[creep].moveTo(closest_object_of_energy);
                    closest_object_of_energy.transferEnergy(current_builders[creep], current_builders[creep].carryCapacity);
                }
            }
        }else{
            var friendly_structures = Game.rooms[name].find(FIND_MY_STRUCTURES, {
                filter: function (structure) {
                    return structure.structureType == 'controller';
                }
            });
            var going_to = {};
            for (var j in friendly_structures) {
                going_to = friendly_structures[j];
                break;
            }
            for (var creep in current_builders) {
                if (current_builders[creep].carry.energy != 0) {
                    current_builders[creep].moveTo(going_to);
                    current_builders[creep].upgradeController(going_to);
                } else {




                    var closest_object_of_energy = current_builders[creep].pos.findClosest(FIND_MY_STRUCTURES, {
                        filter: function (structure) {
                            return  structure.structureType == 'storage' ;
                        }
                    });
                    current_builders[creep].moveTo(closest_object_of_energy);
                    closest_object_of_energy.transferEnergy(current_builders[creep], current_builders[creep].carryCapacity);
                }

            }

        }
    }
}

function _place_extenders(room) {

}