> **Note:** This file is written in Markdown and is best viewed with a Markdown viewer (e.g., GitHub, GitLab, VS Code, or a dedicated Markdown reader). Viewing it in a plain text editor may not render the formatting as intended.

Copyright (c) 2025 Software Tree

# Gilhari Relationships Example

> **Demonstrates one-to-one and one-to-many BYVALUE relationships with advanced query capabilities**

Gilhari is a Docker-compatible microservice framework that provides RESTful Object-Relational Mapping (ORM) functionality for JSON objects with any relational database.

Remarkably, Gilhari automates REST APIs (POST, GET, PUT, DELETE, etc.) handling, JSON CRUD operations, and database schema setup — **no manual coding required**.

## About This Example

This repository contains an example showing how to configure Gilhari to handle both one-to-one and one-to-many relationships using BYVALUE (containment) semantics, along with advanced query capabilities including path expressions and GraphQL-like projections.

The example uses the base Gilhari docker image (softwaretree/gilhari) to easily create a new docker image (gilhari_relationships_example) that can run as a RESTful microservice (server) to persist app specific JSON objects with relational mappings.

This example can be used **standalone as a RESTful microservice** or optionally with the ORMCP Server.

**Related:**
- Main ORMCP Server: [https://github.com/SoftwareTree/ormcp-server](https://github.com/SoftwareTree/ormcp-server)

**Note:** This example is also included in the Gilhari SDK distribution. If you have the SDK installed, you can use it directly from the `examples/gilhari_relationships_example` directory without cloning.

## Example Overview

The example showcases a JSON object model with three types of objects: **A**, **B**, and **C**

**Object Model Overview:**
- **A**: Parent object that contains both a B object and an array of C objects
- **B**: Child object contained by A (one-to-one relationship)
- **C**: Child object contained by A (one-to-many relationship via array)
- **Attributes**: 
  - A: aId (int), aString (string), aBoolean (boolean), aFloat (double), aDate (long/milliseconds), aB (B object), aCs (array of C objects)
  - B: bId (int), aId (int - parent reference), bInt (int), bString (string)
  - C: cId (int), aId (int - parent reference), cInt (int), cString (string)
- **Database Tables**: A, B, C

### What Makes This Example Different?

This example demonstrates **BYVALUE (containment) relationships** with advanced querying:

**Relationship Patterns:**
- **One-to-one**: Each **A object** contains exactly one **B object** (aB attribute)
- **One-to-many**: Each **A object** contains an array of **C objects** (aCs attribute)
- **BYVALUE semantics**: Child objects (B and C) are contained within parent (A)
  - When an A object is deleted, its contained B and C objects are also deleted
  - Child objects are typically created and manipulated through their parent

**Advanced Query Capabilities:**
- **Path expressions**: Query parent objects based on child object attributes (e.g., `jdxObject.aB.bInt>100`)
- **Projections**: Select specific attributes using `operationDetails` parameter
- **Selective following**: Control which relationships to include in shallow queries using `follow` operation
- **Shallow vs deep queries**: Use `deep=false` to exclude relationships, or selectively include them

**Configuration:**
See `config/gilhari_relationships_example.jdx` for how to configure BYVALUE relationships with one-to-one and one-to-many patterns.

### A Object Structure (with contained B and C objects)
```json
{
  "aId": 1,
  "aString": "aString_1",
  "aBoolean": true,
  "aFloat": 1.1,
  "aDate": 347184000001,
  "aB": {
    "bId": 100,
    "aId": 1,
    "bInt": 100,
    "bString": "bString_1"
  },
  "aCs": [
    {
      "cId": 1000,
      "aId": 1,
      "cInt": 100,
      "cString": "cString_1"
    },
    {
      "cId": 2000,
      "aId": 1,
      "cInt": 200,
      "cString": "cString_2"
    }
  ]
}
```

### B Object Structure (child/contained object)
```json
{
  "bId": 100,
  "aId": 1,
  "bInt": 100,
  "bString": "bString_1"
}
```

### C Object Structure (child/contained object)
```json
{
  "cId": 1000,
  "aId": 1,
  "cInt": 100,
  "cString": "cString_1"
}
```

## Project Structure

```
gilhari_relationships_example/
├── src/                           # Container domain model classes
│   └── com/softwaretree/...      # A.java, B.java, C.java
├── config/                        # Configuration files
│   ├── gilhari_relationships_example.jdx  # ORM specification with BYVALUE relationships
│   └── classnames_map_example.js
├── bin/                           # Compiled .class files
├── Dockerfile                     # Docker image definition
├── gilhari_service.config         # Service configuration
├── compile.cmd / .sh              # Compilation scripts
├── build.cmd / .sh                # Docker build scripts
├── run_docker_app.cmd / .sh       # Docker run scripts
├── curlCommands.cmd / .sh         # API testing scripts
└── curlCommandsPopulate.cmd / .sh # Sample data population scripts
```

## Source Code
The `src` directory contains the declarations of the underlying shell (container) classes (e.g., A, B, C) that are used to define the object-relational mapping (ORM) specification for the corresponding conceptual domain-specific JSON object model classes:

- **A, B, and C classes**: Simple shell (container) classes (.java files) corresponding to the domain-specific JSON object model classes of related entities (Container domain model classes)
- **JDX_JSONObject**: Base class of the container domain model classes for handling persistence of domain-specific JSON objects
- **Container domain model classes**: Only need to define two constructors, with most processing handled by the JDX_JSONObject superclass

**Note:** Gilhari does not require any explicit programmatic definitions (e.g., ES6 style JavaScript classes) for domain-specific JSON object model classes. It handles the data of domain-specific JSON objects using instances of the container domain model classes and the ORM specification.

## Configurations

A declarative ORM specification for the domain-specific JSON object model classes and their attributes is defined in `config/gilhari_relationships_example.jdx` using the container domain model classes. This file defines the mappings between JSON objects and database tables, **including BYVALUE relationship configurations**.

**Key points:**
- Update the database URL and JDBC driver in this file according to your setup
- See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide` (.md or .html) for guides on configuring different databases
- The container domain model classes (like A, B, C) corresponding to the conceptual domain-specific JSON object model classes are defined as subclasses of the JDX_JSONObject class
- Appropriate mappings for the domain-specific JSON object model classes are defined in the ORM specification file using the corresponding container domain model classes
- **BYVALUE relationship configuration** establishes containment semantics where child objects are owned by their parent

For comprehensive details on defining and using container classes and the ORM specification for JSON object models, refer to the **"Persisting JSON Objects"** section in the JDX User Manual.

### BYVALUE Relationship Configuration

The key to this example is in the ORM specification file (`config/gilhari_relationships_example.jdx`), where relationships are configured using BYVALUE semantics.

**One-to-One Relationship (A to B):**
```
CLASS .A TABLE A
    ...
    RELATIONSHIP aB REFERENCES .B BYVALUE REFERENCED_KEY parentId WITH aId
;

CLASS .B TABLE B
    VIRTUAL_ATTRIB bId ATTRIB_TYPE int
    VIRTUAL_ATTRIB aId ATTRIB_TYPE int
    ...
    PRIMARY_KEY bId 
    REFERENCE_KEY parentId aId
;
```

**One-to-Many Relationship (A to C array):**
```
CLASS .A TABLE A
    ...
    RELATIONSHIP aCs REFERENCES ArrayC BYVALUE WITH aId
;

CLASS .C TABLE C
    VIRTUAL_ATTRIB cId ATTRIB_TYPE int
    VIRTUAL_ATTRIB aId ATTRIB_TYPE int
    ...
    PRIMARY_KEY cId 
;

COLLECTION_CLASS ArrayC COLLECTION_TYPE ARRAY ELEMENT_CLASS .C
    PRIMARY_KEY aId 
;
```

**BYVALUE Semantics:**
- Child objects (B and C) are contained within their parent (A)
- Deleting an A object also deletes its contained B and C objects
- Objects are typically managed as a unit through the parent

**Note:** The .jdx file includes commented examples of caching configurations for performance optimization.

### Docker Configuration

The `Dockerfile` builds a RESTful Gilhari microservice using:
- Base Gilhari image (softwaretree/gilhari)
- Compiled domain model (.class) files
- Configuration files including the ORM specification and a JDBC driver

### Service Configuration

The `gilhari_service.config` file specifies runtime parameters for the RESTful Gilhari microservice:

```json
{
  "gilhari_microservice_name": "gilhari_relationships_example",
  "jdx_orm_spec_file": "./config/gilhari_relationships_example.jdx",
  "jdbc_driver_path": "/node/node_modules/jdxnode/external_libs/sqlite-jdbc-3.50.3.0.jar",
  "jdx_debug_level": 5,
  "jdx_force_create_schema": "true",
  "jdx_persistent_classes_location": "./bin",
  "classnames_map_file": "config/classnames_map_example.js",
  "gilhari_rest_server_port": 8081
}
```

#### Service Configuration Parameters

| Parameter | Description | Default |
|-----------|-------------|---------|
| `gilhari_microservice_name` | Optional name to identify this Gilhari microservice. The name is logged on console during start up | - |
| `jdx_orm_spec_file` | Location of the ORM specification file containing mapping for persistent classes | - |
| `jdbc_driver_path` | Path to the JDBC driver (.jar) file. SQLite driver included by default | - |
| `jdx_debug_level` | Debug output level (0-5). 0 = most verbose, 5 = minimal. Level 3 outputs all SQL statements | 5 |
| `jdx_force_create_schema` | Whether to recreate database schema on each run. `true` = useful for development, `false` = create only once | false |
| `jdx_persistent_classes_location` | Root location for compiled persistent (Container domain model) classes. Can be a directory (e.g., ./bin) or a JAR file path. Used as a Java CLASSPATH  | - |
| `classnames_map_file` | Optional JSON file that can map names of container domain model classes to (simpler) object class (type) names (e.g., by omitting a package name) to simplify REST URL| - |
| `gilhari_rest_server_port` | Port number for the RESTful service. This port number may be mapped to different port number (e.g., 80) by a docker run command. | 8081 |


## Build Files
- `compile.cmd` / `compile.sh`: Compiles the container domain model classes
- `sources.txt`: Lists the names of the container domain model class source (.java) files for compilation
- `build.cmd` / `build.sh`: Creates the Gilhari Docker image (gilhari_relationships_example) using the local Dockerfile

**Note**: Compilation targets JDK version 1.8, which is compatible with the current Gilhari version.

## Quick Start

### For Quick Evaluation (No SDK Required)
If you just want to see this example in action without modifications:

1. **Clone this repository** (pre-compiled classes included)
2. **Install Docker**
3. **Build and run** (skip compilation step)

### For Development and Customization
If you want to modify the object model or create your own Gilhari microservices:

1. **Gilhari SDK**: Download and install from [https://softwaretree.com](https://softwaretree.com)
2. **JX_HOME environment variable**: Set to the root directory of your Gilhari SDK installation
3. **Java Development Kit (JDK 1.8+)** for compilation
4. **Docker** installed on your system

**Note:** The Gilhari SDK contains necessary libraries (JARs) and base classes required for compiling container domain model classes. While pre-compiled `.class` files are included in this repository for immediate use, you'll need the SDK to make any modifications to the object model or to create your own Gilhari microservices.

## Build and Run

### Option 1: Quick Run (Using Pre-compiled Classes)

**Skip compilation** and go straight to Docker:

```bash
# Windows
build.cmd
run_docker_app.cmd

# Linux/Mac
./build.sh
./run_docker_app.sh
```

### Option 2: Compile and Run (For Modifications)

**If you've made changes to the source code:**

1. **Ensure JX_HOME is set** to your Gilhari SDK installation directory

2. **Compile the classes**:
   ```bash
   # Windows
   compile.cmd
   
   # Linux/Mac
   ./compile.sh
   ```

3. **Build and run the Docker container**:
   ```bash
   # Windows
   build.cmd
   run_docker_app.cmd
   
   # Linux/Mac
   ./build.sh
   ./run_docker_app.sh
   ```

## REST API Usage

Once running, access the Gilhari microservice at:

```
http://localhost:<port>/gilhari/v1/:className
```

**Example endpoints:**
```
http://localhost:80/gilhari/v1/A
http://localhost:80/gilhari/v1/B
http://localhost:80/gilhari/v1/C
http://localhost:80/gilhari/v1/health/check
```

### Supported HTTP Methods

| Method | Purpose | Example |
|--------|---------|---------|
| GET | Retrieve objects | `GET /gilhari/v1/A` |
| POST | Create objects | `POST /gilhari/v1/A` |
| PUT | Update objects | `PUT /gilhari/v1/A` |
| PATCH | Partial update | `PATCH /gilhari/v1/A` |
| DELETE | Delete objects | `DELETE /gilhari/v1/A` |

### Example Operations

**Create A object with contained B and C objects:**
```bash
curl -X POST http://localhost:80/gilhari/v1/A \
  -H "Content-Type: application/json" \
  -d '{
    "entity": {
      "aId": 1,
      "aString": "aString_1",
      "aBoolean": true,
      "aFloat": 1.1,
      "aDate": 347184000001,
      "aB": {
        "bId": 100,
        "aId": 1,
        "bInt": 100,
        "bString": "bString_1"
      },
      "aCs": [
        {
          "cId": 1000,
          "aId": 1,
          "cInt": 100,
          "cString": "cString_1"
        },
        {
          "cId": 2000,
          "aId": 1,
          "cInt": 200,
          "cString": "cString_2"
        }
      ]
    }
  }'
```

**Query all A objects (deep - includes B and C):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/A" \
  -H "Content-Type: application/json"
```

**Shallow query (exclude relationships):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/A?deep=false" \
  -H "Content-Type: application/json"
```

**Query with path expression (filter by child attribute):**
```bash
curl -X GET "http://localhost:80/gilhari/v1/A?filter=jdxObject.aB.bInt>100" \
  -H "Content-Type: application/json"
```

**Shallow query with selective follow (include only aB):**
```bash
curl -G "http://localhost:80/gilhari/v1/A" \
  --data-urlencode "deep=false" \
  --data-urlencode 'operationDetails=[{"opType": "follow", "references": ["A", "aB"]}]' \
  -H "Content-Type: application/json"
```

**Projections with selective attributes:**
```bash
curl -G "http://localhost:80/gilhari/v1/A" \
  --data-urlencode "deep=false" \
  --data-urlencode 'operationDetails=[{"opType": "projections", "projectionsDetails": [{"type": "A", "attribs": ["aId", "aString"]}]}]' \
  -H "Content-Type: application/json"
```

**Combined projections and follow:**
```bash
curl -G "http://localhost:80/gilhari/v1/A" \
  --data-urlencode "deep=false" \
  --data-urlencode 'operationDetails=[{"opType": "projections", "projectionsDetails": [{"type": "A", "attribs": ["aId", "aString"]}]}, {"opType": "follow", "references": ["A", "aB"]}]' \
  -H "Content-Type: application/json"
```

**Delete A object (cascades to B and C):**
```bash
curl -X DELETE "http://localhost:80/gilhari/v1/A?filter=aId=1"
```

### Testing the API

**Comprehensive test scripts:**

1. **curlCommands.cmd / .sh** - Complete demonstration of relationship operations

   Demonstrates:
   - Health check endpoint
   - Creating A objects with and without contained objects
   - Deep and shallow queries
   - Path expressions for filtering
   - Cascading deletes (BYVALUE behavior)
   - Aggregate operations

2. **curlCommandsPopulate.cmd / .sh** - Advanced query demonstrations

   Demonstrates:
   - All features from curlCommands
   - **Projections** using `operationDetails` for selecting specific attributes
   - **Selective follow** operations to include only specific relationships
   - **Combined operations** (projections + follow)
   - **MaxObjects** parameter for limiting results

Run the scripts to generate a `curl.log` file with all responses:
```bash
# Windows
curlCommands.cmd
curlCommandsPopulate.cmd

# Linux/Mac
chmod +x curlCommands.sh curlCommandsPopulate.sh
./curlCommands.sh
./curlCommandsPopulate.sh

# Custom port
curlCommands.cmd 8899
curlCommandsPopulate.sh 8899
```

The scripts will create a `curl.log` file with all the API responses, demonstrating relationship management and advanced query capabilities including path expressions, projections, and selective following.

**Note:** The **`operationDetails`** parameter in a query allows you to fine-tune query operations with operational directives similar to **GraphQL** capabilities. It accepts a JSON array containing one or more operation directives that refine the shape and scope of returned objects. For more details, see `operationDetails_doc.md`.

**Other options:**
- **Postman**: Import the endpoints for interactive testing
- **Browser**: Access GET endpoints directly
- **Any REST Client**: Standard HTTP methods work with any REST client
- **ORMCP Server** (optional): Use ORMCP Server tools for AI-powered interactions

## Using with ORMCP Server (Optional)

This Gilhari microservice can be used with the ORMCP Server for AI-powered database interactions:

1. **Start this Gilhari microservice** (as shown in Quick Start)
2. **Configure ORMCP Server** to connect to this microservice endpoint
3. **Use ORMCP tools** to query and manipulate A, B, and C objects through natural language

The ORMCP Server will automatically handle the relationship navigation and understand the BYVALUE containment semantics.

## Development Tools

### Docker Container Access
Shell into a running container:
```bash
# Find container ID
docker ps

# Access container
docker exec -it <container-id> bash
```

### View Logs
```bash
docker logs <container-id>
```

### Stop Container
```bash
docker stop <container-id>
```

## Additional Resources

- **JDX User Manual**: "Persisting JSON Objects" section for detailed ORM specification documentation
- **Gilhari SDK Documentation**: The SDK available for download at [https://softwaretree.com](https://softwaretree.com)
- **ORMCP Server**: Main repository at [https://github.com/SoftwareTree/ormcp-server](https://github.com/SoftwareTree/ormcp-server)
- **Database Configuration Guide**: See `JDX_DATABASE_JDBC_DRIVER_Specification_Guide.md`
- **operationDetails Documentation**: See `operationDetails_doc.md` for GraphQL-like query capabilities

## Platform Notes

Script files are provided for both Windows (`.cmd`) and Linux/Mac (`.sh`). 

**Linux/Mac users**: Make scripts executable before running:
```bash
chmod +x *.sh
```

## Troubleshooting

### Common Issues

**Problem**: Docker image build fails
- **Solution**: Ensure the base Gilhari image is pulled: `docker pull softwaretree/gilhari`

**Problem**: Compilation errors
- **Solution**: Verify JDK 1.8+ is installed and JX_HOME environment variable is set correctly

**Problem**: Port 80 already in use
- **Solution**: Modify `run_docker_app` script to use a different port (e.g., `-p 8080:8081`)

**Problem**: Database connection errors
- **Solution**: Check `config/gilhari_relationships_example.jdx` for correct database URL and JDBC driver path

**Problem**: Child objects (B, C) not deleted when parent (A) is deleted
- **Solution**: This example uses BYVALUE semantics - child objects should be deleted. Verify the ORM specification has BYVALUE configured for the relationships

**Problem**: Path expressions not working (e.g., `jdxObject.aB.bInt>100`)
- **Solution**: Ensure the path expression syntax is correct and properly URL-encoded. The `jdxObject` prefix is required for navigating relationships

**Problem**: Projections or follow operations not working
- **Solution**: Ensure the `operationDetails` parameter is properly URL-encoded. Use `--data-urlencode` with curl

## Support

For issues or questions:
- **ORMCP Server issues**: [https://github.com/SoftwareTree/ormcp-server/issues](https://github.com/SoftwareTree/ormcp-server/issues)
- **This example**: [https://github.com/SoftwareTree/gilhari_relationships_example/issues](https://github.com/SoftwareTree/gilhari_relationships_example/issues)
- **Gilhari SDK**: Contact support at [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com)

## License

This example code is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

**Important:** This license applies ONLY to the example code in this repository. The Gilhari software (including the softwaretree/gilhari Docker image and Gilhari SDK) and the embedded JDX ORM software are proprietary products owned by Software Tree.

The Gilhari Docker image includes an evaluation license for testing purposes. For production use or licensing beyond the evaluation period, please visit [https://www.softwaretree.com](https://www.softwaretree.com) or contact [gilhari_support@softwaretree.com](mailto:gilhari_support@softwaretree.com).

---

**Ready to try it?** Start with the [Quick Start](#quick-start) section above!