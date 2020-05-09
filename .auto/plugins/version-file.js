const fs = require('fs');
const execPromise = require('@auto-it/core').execPromise;

module.exports = class VersionFilePlugin {
    constructor(config) {
        this.config = config;
        this.name = 'version-file';
    }

    /**
     * Setup the plugin
     * @param {import('@auto-it/core').default} auto
     */
    apply(auto) {
        // hook into auto
        auto.hooks.beforeCommitChangelog.tap(
            'VersionFile',
            async ({ currentVersion, commits, releaseNotes, lastRelease }) => {
                // do something
                fs.writeFileSync('./VERSION', currentVersion);
                await execPromise("git", ["add", "VERSION"]);
            }
        );
    }
};