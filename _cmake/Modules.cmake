function(add_module module)
  include("${CMAKE_SOURCE_DIR}/src/modules/${module}/.cmake")
endfunction()

# modules that this module depends on.
# module_depends_on([<module>...])
function(module_depends_on)
  # extract directory name in module_name and replaces white space with '_'
  cmake_path(GET CMAKE_CURRENT_LIST_DIR FILENAME module_name)
  string(REPLACE " " "_" module_name ${module_name})

  # link module to dependencies (other modules)
  target_link_libraries(${module_name}
    ${ARGV}
  )
endfunction()

# source files of this module.
# modules_sources([<source>...])
function(module_sources)
  # extract the current directory name into module_name to be used as module's name
  cmake_path(GET CMAKE_CURRENT_LIST_DIR FILENAME module_name)

  # replaces white space in module_name with '_'
  string(REPLACE " " "_" module_name ${module_name})

  # holds a list of test sources
  set(sources_list)

  # build the list of sources from function arguments
  foreach(source ${ARGV})
    list(APPEND
      sources_list
      "${CMAKE_SOURCE_DIR}/src/modules/${module_name}/${source}"
    )
  endforeach()

  # add module as a static library using its source files
  add_library(${module_name}
    STATIC
    ${sources_list}
  )

  # include directory (current dir of module)
  target_include_directories(${module_name}
    PUBLIC
    "${CMAKE_SOURCE_DIR}/src/modules/${module_name}"
    "${CMAKE_SOURCE_DIR}/src/modules/${module_name}/include"
    "${CMAKE_SOURCE_DIR}/src/modules/${module_name}/headers"
  )

  # link module to the project executable
  target_link_libraries(${PROJECT_NAME}
    ${module_name}
  )
endfunction()