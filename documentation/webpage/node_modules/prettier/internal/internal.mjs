import { createRequire as __prettierCreateRequire } from "module";
import { fileURLToPath as __prettierFileUrlToPath } from "url";
import { dirname as __prettierDirname } from "path";
const require = __prettierCreateRequire(import.meta.url);
const __filename = __prettierFileUrlToPath(import.meta.url);
const __dirname = __prettierDirname(__filename);

var __create = Object.create;
var __defProp = Object.defineProperty;
var __getOwnPropDesc = Object.getOwnPropertyDescriptor;
var __getOwnPropNames = Object.getOwnPropertyNames;
var __getProtoOf = Object.getPrototypeOf;
var __hasOwnProp = Object.prototype.hasOwnProperty;
var __require = /* @__PURE__ */ ((x) => typeof require !== "undefined" ? require : typeof Proxy !== "undefined" ? new Proxy(x, {
  get: (a, b) => (typeof require !== "undefined" ? require : a)[b]
}) : x)(function(x) {
  if (typeof require !== "undefined")
    return require.apply(this, arguments);
  throw Error('Dynamic require of "' + x + '" is not supported');
});
var __commonJS = (cb, mod) => function __require2() {
  return mod || (0, cb[__getOwnPropNames(cb)[0]])((mod = { exports: {} }).exports, mod), mod.exports;
};
var __copyProps = (to, from, except, desc) => {
  if (from && typeof from === "object" || typeof from === "function") {
    for (let key of __getOwnPropNames(from))
      if (!__hasOwnProp.call(to, key) && key !== except)
        __defProp(to, key, { get: () => from[key], enumerable: !(desc = __getOwnPropDesc(from, key)) || desc.enumerable });
  }
  return to;
};
var __toESM = (mod, isNodeMode, target) => (target = mod != null ? __create(__getProtoOf(mod)) : {}, __copyProps(
  // If the importer is in node compatibility mode or this is not an ESM
  // file that has been converted to a CommonJS file using a Babel-
  // compatible transform (i.e. "__esModule" has not been set), then set
  // "default" to the CommonJS "module.exports" for node compatibility.
  isNodeMode || !mod || !mod.__esModule ? __defProp(target, "default", { value: mod, enumerable: true }) : target,
  mod
));

// node_modules/lilconfig/dist/index.js
var require_dist = __commonJS({
  "node_modules/lilconfig/dist/index.js"(exports) {
    "use strict";
    Object.defineProperty(exports, "__esModule", { value: true });
    exports.lilconfigSync = exports.lilconfig = exports.defaultLoaders = void 0;
    var path = __require("path");
    var fs2 = __require("fs");
    var os = __require("os");
    var fsReadFileAsync = fs2.promises.readFile;
    function getDefaultSearchPlaces(name) {
      return [
        "package.json",
        `.${name}rc.json`,
        `.${name}rc.js`,
        `.${name}rc.cjs`,
        `.config/${name}rc`,
        `.config/${name}rc.json`,
        `.config/${name}rc.js`,
        `.config/${name}rc.cjs`,
        `${name}.config.js`,
        `${name}.config.cjs`
      ];
    }
    function getSearchPaths(startDir, stopDir) {
      return startDir.split(path.sep).reduceRight((acc, _, ind, arr) => {
        const currentPath = arr.slice(0, ind + 1).join(path.sep);
        if (!acc.passedStopDir)
          acc.searchPlaces.push(currentPath || path.sep);
        if (currentPath === stopDir)
          acc.passedStopDir = true;
        return acc;
      }, { searchPlaces: [], passedStopDir: false }).searchPlaces;
    }
    exports.defaultLoaders = Object.freeze({
      ".js": __require,
      ".json": __require,
      ".cjs": __require,
      noExt(_, content) {
        return JSON.parse(content);
      }
    });
    function getExtDesc(ext) {
      return ext === "noExt" ? "files without extensions" : `extension "${ext}"`;
    }
    function getOptions(name, options = {}) {
      const conf = {
        stopDir: os.homedir(),
        searchPlaces: getDefaultSearchPlaces(name),
        ignoreEmptySearchPlaces: true,
        transform: (x) => x,
        packageProp: [name],
        ...options,
        loaders: { ...exports.defaultLoaders, ...options.loaders }
      };
      conf.searchPlaces.forEach((place) => {
        const key = path.extname(place) || "noExt";
        const loader = conf.loaders[key];
        if (!loader) {
          throw new Error(`No loader specified for ${getExtDesc(key)}, so searchPlaces item "${place}" is invalid`);
        }
        if (typeof loader !== "function") {
          throw new Error(`loader for ${getExtDesc(key)} is not a function (type provided: "${typeof loader}"), so searchPlaces item "${place}" is invalid`);
        }
      });
      return conf;
    }
    function getPackageProp(props, obj) {
      if (typeof props === "string" && props in obj)
        return obj[props];
      return (Array.isArray(props) ? props : props.split(".")).reduce((acc, prop) => acc === void 0 ? acc : acc[prop], obj) || null;
    }
    function getSearchItems(searchPlaces, searchPaths) {
      return searchPaths.reduce((acc, searchPath) => {
        searchPlaces.forEach((sp) => acc.push({
          searchPlace: sp,
          filepath: path.join(searchPath, sp),
          loaderKey: path.extname(sp) || "noExt"
        }));
        return acc;
      }, []);
    }
    function validateFilePath(filepath) {
      if (!filepath)
        throw new Error("load must pass a non-empty string");
    }
    function validateLoader(loader, ext) {
      if (!loader)
        throw new Error(`No loader specified for extension "${ext}"`);
      if (typeof loader !== "function")
        throw new Error("loader is not a function");
    }
    function lilconfig2(name, options) {
      const { ignoreEmptySearchPlaces, loaders, packageProp, searchPlaces, stopDir, transform } = getOptions(name, options);
      return {
        async search(searchFrom = process.cwd()) {
          const searchPaths = getSearchPaths(searchFrom, stopDir);
          const result = {
            config: null,
            filepath: ""
          };
          const searchItems = getSearchItems(searchPlaces, searchPaths);
          for (const { searchPlace, filepath, loaderKey } of searchItems) {
            try {
              await fs2.promises.access(filepath);
            } catch (_a) {
              continue;
            }
            const content = String(await fsReadFileAsync(filepath));
            const loader = loaders[loaderKey];
            if (searchPlace === "package.json") {
              const pkg = await loader(filepath, content);
              const maybeConfig = getPackageProp(packageProp, pkg);
              if (maybeConfig != null) {
                result.config = maybeConfig;
                result.filepath = filepath;
                break;
              }
              continue;
            }
            const isEmpty = content.trim() === "";
            if (isEmpty && ignoreEmptySearchPlaces)
              continue;
            if (isEmpty) {
              result.isEmpty = true;
              result.config = void 0;
            } else {
              validateLoader(loader, loaderKey);
              result.config = await loader(filepath, content);
            }
            result.filepath = filepath;
            break;
          }
          if (result.filepath === "" && result.config === null)
            return transform(null);
          return transform(result);
        },
        async load(filepath) {
          validateFilePath(filepath);
          const absPath = path.resolve(process.cwd(), filepath);
          const { base, ext } = path.parse(absPath);
          const loaderKey = ext || "noExt";
          const loader = loaders[loaderKey];
          validateLoader(loader, loaderKey);
          const content = String(await fsReadFileAsync(absPath));
          if (base === "package.json") {
            const pkg = await loader(absPath, content);
            return transform({
              config: getPackageProp(packageProp, pkg),
              filepath: absPath
            });
          }
          const result = {
            config: null,
            filepath: absPath
          };
          const isEmpty = content.trim() === "";
          if (isEmpty && ignoreEmptySearchPlaces)
            return transform({
              config: void 0,
              filepath: absPath,
              isEmpty: true
            });
          result.config = isEmpty ? void 0 : await loader(absPath, content);
          return transform(isEmpty ? { ...result, isEmpty, config: void 0 } : result);
        }
      };
    }
    exports.lilconfig = lilconfig2;
  }
});

// node_modules/find-parent-dir/index.js
var require_find_parent_dir = __commonJS({
  "node_modules/find-parent-dir/index.js"(exports, module) {
    "use strict";
    var path = __require("path");
    var fs2 = __require("fs");
    var exists = fs2.exists || path.exists;
    var existsSync = fs2.existsSync || path.existsSync;
    function splitPath(path2) {
      var parts = path2.split(/(\/|\\)/);
      if (!parts.length)
        return parts;
      return !parts[0].length ? parts.slice(1) : parts;
    }
    exports = module.exports = function(currentFullPath, clue, cb) {
      function testDir(parts) {
        if (parts.length === 0)
          return cb(null, null);
        var p = parts.join("");
        exists(path.join(p, clue), function(itdoes) {
          if (itdoes)
            return cb(null, p);
          testDir(parts.slice(0, -1));
        });
      }
      testDir(splitPath(currentFullPath));
    };
    exports.sync = function(currentFullPath, clue) {
      function testDir(parts) {
        if (parts.length === 0)
          return null;
        var p = parts.join("");
        var itdoes = existsSync(path.join(p, clue));
        return itdoes ? p : testDir(parts.slice(0, -1));
      }
      return testDir(splitPath(currentFullPath));
    };
  }
});

// node_modules/ci-info/vendors.json
var require_vendors = __commonJS({
  "node_modules/ci-info/vendors.json"(exports, module) {
    module.exports = [
      {
        name: "Agola CI",
        constant: "AGOLA",
        env: "AGOLA_GIT_REF",
        pr: "AGOLA_PULL_REQUEST_ID"
      },
      {
        name: "Appcircle",
        constant: "APPCIRCLE",
        env: "AC_APPCIRCLE"
      },
      {
        name: "AppVeyor",
        constant: "APPVEYOR",
        env: "APPVEYOR",
        pr: "APPVEYOR_PULL_REQUEST_NUMBER"
      },
      {
        name: "AWS CodeBuild",
        constant: "CODEBUILD",
        env: "CODEBUILD_BUILD_ARN"
      },
      {
        name: "Azure Pipelines",
        constant: "AZURE_PIPELINES",
        env: "TF_BUILD",
        pr: {
          BUILD_REASON: "PullRequest"
        }
      },
      {
        name: "Bamboo",
        constant: "BAMBOO",
        env: "bamboo_planKey"
      },
      {
        name: "Bitbucket Pipelines",
        constant: "BITBUCKET",
        env: "BITBUCKET_COMMIT",
        pr: "BITBUCKET_PR_ID"
      },
      {
        name: "Bitrise",
        constant: "BITRISE",
        env: "BITRISE_IO",
        pr: "BITRISE_PULL_REQUEST"
      },
      {
        name: "Buddy",
        constant: "BUDDY",
        env: "BUDDY_WORKSPACE_ID",
        pr: "BUDDY_EXECUTION_PULL_REQUEST_ID"
      },
      {
        name: "Buildkite",
        constant: "BUILDKITE",
        env: "BUILDKITE",
        pr: {
          env: "BUILDKITE_PULL_REQUEST",
          ne: "false"
        }
      },
      {
        name: "CircleCI",
        constant: "CIRCLE",
        env: "CIRCLECI",
        pr: "CIRCLE_PULL_REQUEST"
      },
      {
        name: "Cirrus CI",
        constant: "CIRRUS",
        env: "CIRRUS_CI",
        pr: "CIRRUS_PR"
      },
      {
        name: "Codefresh",
        constant: "CODEFRESH",
        env: "CF_BUILD_ID",
        pr: {
          any: [
            "CF_PULL_REQUEST_NUMBER",
            "CF_PULL_REQUEST_ID"
          ]
        }
      },
      {
        name: "Codemagic",
        constant: "CODEMAGIC",
        env: "CM_BUILD_ID",
        pr: "CM_PULL_REQUEST"
      },
      {
        name: "Codeship",
        constant: "CODESHIP",
        env: {
          CI_NAME: "codeship"
        }
      },
      {
        name: "Drone",
        constant: "DRONE",
        env: "DRONE",
        pr: {
          DRONE_BUILD_EVENT: "pull_request"
        }
      },
      {
        name: "dsari",
        constant: "DSARI",
        env: "DSARI"
      },
      {
        name: "Earthly",
        constant: "EARTHLY",
        env: "EARTHLY_CI"
      },
      {
        name: "Expo Application Services",
        constant: "EAS",
        env: "EAS_BUILD"
      },
      {
        name: "Gerrit",
        constant: "GERRIT",
        env: "GERRIT_PROJECT"
      },
      {
        name: "Gitea Actions",
        constant: "GITEA_ACTIONS",
        env: "GITEA_ACTIONS"
      },
      {
        name: "GitHub Actions",
        constant: "GITHUB_ACTIONS",
        env: "GITHUB_ACTIONS",
        pr: {
          GITHUB_EVENT_NAME: "pull_request"
        }
      },
      {
        name: "GitLab CI",
        constant: "GITLAB",
        env: "GITLAB_CI",
        pr: "CI_MERGE_REQUEST_ID"
      },
      {
        name: "GoCD",
        constant: "GOCD",
        env: "GO_PIPELINE_LABEL"
      },
      {
        name: "Google Cloud Build",
        constant: "GOOGLE_CLOUD_BUILD",
        env: "BUILDER_OUTPUT"
      },
      {
        name: "Harness CI",
        constant: "HARNESS",
        env: "HARNESS_BUILD_ID"
      },
      {
        name: "Heroku",
        constant: "HEROKU",
        env: {
          env: "NODE",
          includes: "/app/.heroku/node/bin/node"
        }
      },
      {
        name: "Hudson",
        constant: "HUDSON",
        env: "HUDSON_URL"
      },
      {
        name: "Jenkins",
        constant: "JENKINS",
        env: [
          "JENKINS_URL",
          "BUILD_ID"
        ],
        pr: {
          any: [
            "ghprbPullId",
            "CHANGE_ID"
          ]
        }
      },
      {
        name: "LayerCI",
        constant: "LAYERCI",
        env: "LAYERCI",
        pr: "LAYERCI_PULL_REQUEST"
      },
      {
        name: "Magnum CI",
        constant: "MAGNUM",
        env: "MAGNUM"
      },
      {
        name: "Netlify CI",
        constant: "NETLIFY",
        env: "NETLIFY",
        pr: {
          env: "PULL_REQUEST",
          ne: "false"
        }
      },
      {
        name: "Nevercode",
        constant: "NEVERCODE",
        env: "NEVERCODE",
        pr: {
          env: "NEVERCODE_PULL_REQUEST",
          ne: "false"
        }
      },
      {
        name: "Prow",
        constant: "PROW",
        env: "PROW_JOB_ID"
      },
      {
        name: "ReleaseHub",
        constant: "RELEASEHUB",
        env: "RELEASE_BUILD_ID"
      },
      {
        name: "Render",
        constant: "RENDER",
        env: "RENDER",
        pr: {
          IS_PULL_REQUEST: "true"
        }
      },
      {
        name: "Sail CI",
        constant: "SAIL",
        env: "SAILCI",
        pr: "SAIL_PULL_REQUEST_NUMBER"
      },
      {
        name: "Screwdriver",
        constant: "SCREWDRIVER",
        env: "SCREWDRIVER",
        pr: {
          env: "SD_PULL_REQUEST",
          ne: "false"
        }
      },
      {
        name: "Semaphore",
        constant: "SEMAPHORE",
        env: "SEMAPHORE",
        pr: "PULL_REQUEST_NUMBER"
      },
      {
        name: "Sourcehut",
        constant: "SOURCEHUT",
        env: {
          CI_NAME: "sourcehut"
        }
      },
      {
        name: "Strider CD",
        constant: "STRIDER",
        env: "STRIDER"
      },
      {
        name: "TaskCluster",
        constant: "TASKCLUSTER",
        env: [
          "TASK_ID",
          "RUN_ID"
        ]
      },
      {
        name: "TeamCity",
        constant: "TEAMCITY",
        env: "TEAMCITY_VERSION"
      },
      {
        name: "Travis CI",
        constant: "TRAVIS",
        env: "TRAVIS",
        pr: {
          env: "TRAVIS_PULL_REQUEST",
          ne: "false"
        }
      },
      {
        name: "Vela",
        constant: "VELA",
        env: "VELA",
        pr: {
          VELA_PULL_REQUEST: "1"
        }
      },
      {
        name: "Vercel",
        constant: "VERCEL",
        env: {
          any: [
            "NOW_BUILDER",
            "VERCEL"
          ]
        },
        pr: "VERCEL_GIT_PULL_REQUEST_ID"
      },
      {
        name: "Visual Studio App Center",
        constant: "APPCENTER",
        env: "APPCENTER_BUILD_ID"
      },
      {
        name: "Woodpecker",
        constant: "WOODPECKER",
        env: {
          CI: "woodpecker"
        },
        pr: {
          CI_BUILD_EVENT: "pull_request"
        }
      },
      {
        name: "Xcode Cloud",
        constant: "XCODE_CLOUD",
        env: "CI_XCODE_PROJECT",
        pr: "CI_PULL_REQUEST_NUMBER"
      },
      {
        name: "Xcode Server",
        constant: "XCODE_SERVER",
        env: "XCS"
      }
    ];
  }
});

// node_modules/ci-info/index.js
var require_ci_info = __commonJS({
  "node_modules/ci-info/index.js"(exports) {
    "use strict";
    var vendors = require_vendors();
    var env = process.env;
    Object.defineProperty(exports, "_vendors", {
      value: vendors.map(function(v) {
        return v.constant;
      })
    });
    exports.name = null;
    exports.isPR = null;
    vendors.forEach(function(vendor) {
      const envs = Array.isArray(vendor.env) ? vendor.env : [vendor.env];
      const isCI2 = envs.every(function(obj) {
        return checkEnv(obj);
      });
      exports[vendor.constant] = isCI2;
      if (!isCI2) {
        return;
      }
      exports.name = vendor.name;
      switch (typeof vendor.pr) {
        case "string":
          exports.isPR = !!env[vendor.pr];
          break;
        case "object":
          if ("env" in vendor.pr) {
            exports.isPR = vendor.pr.env in env && env[vendor.pr.env] !== vendor.pr.ne;
          } else if ("any" in vendor.pr) {
            exports.isPR = vendor.pr.any.some(function(key) {
              return !!env[key];
            });
          } else {
            exports.isPR = checkEnv(vendor.pr);
          }
          break;
        default:
          exports.isPR = null;
      }
    });
    exports.isCI = !!(env.CI !== "false" && // Bypass all checks if CI env is explicitly set to 'false'
    (env.BUILD_ID || // Jenkins, Cloudbees
    env.BUILD_NUMBER || // Jenkins, TeamCity
    env.CI || // Travis CI, CircleCI, Cirrus CI, Gitlab CI, Appveyor, CodeShip, dsari
    env.CI_APP_ID || // Appflow
    env.CI_BUILD_ID || // Appflow
    env.CI_BUILD_NUMBER || // Appflow
    env.CI_NAME || // Codeship and others
    env.CONTINUOUS_INTEGRATION || // Travis CI, Cirrus CI
    env.RUN_ID || // TaskCluster, dsari
    exports.name || false));
    function checkEnv(obj) {
      if (typeof obj === "string")
        return !!env[obj];
      if ("env" in obj) {
        return env[obj.env] && env[obj.env].includes(obj.includes);
      }
      if ("any" in obj) {
        return obj.any.some(function(k) {
          return !!env[k];
        });
      }
      return Object.keys(obj).every(function(k) {
        return env[k] === obj[k];
      });
    }
  }
});

// src/common/mockable.js
var import_lilconfig = __toESM(require_dist(), 1);
var import_find_parent_dir = __toESM(require_find_parent_dir(), 1);
import fs from "fs/promises";

// node_modules/get-stdin/index.js
var { stdin } = process;
async function getStdin() {
  let result = "";
  if (stdin.isTTY) {
    return result;
  }
  stdin.setEncoding("utf8");
  for await (const chunk of stdin) {
    result += chunk;
  }
  return result;
}
getStdin.buffer = async () => {
  const result = [];
  let length = 0;
  if (stdin.isTTY) {
    return Buffer.concat([]);
  }
  for await (const chunk of stdin) {
    result.push(chunk);
    length += chunk.length;
  }
  return Buffer.concat(result, length);
};

// src/common/mockable.js
var import_ci_info = __toESM(require_ci_info(), 1);
function writeFormattedFile(file, data) {
  return fs.writeFile(file, data);
}
var mockable = {
  lilconfig: import_lilconfig.lilconfig,
  findParentDir: import_find_parent_dir.sync,
  getStdin,
  isCI: () => import_ci_info.isCI,
  writeFormattedFile
};
var mockable_default = mockable;
export {
  mockable_default as default
};
