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
                auto.logger.verbose.info(`!!! in beforeCommitChangelog, currentVersion: ${currentVersion}, commits: ${commits}, notes: ${releaseNotes}, lastRelease: ${lastRelease}`)
                const versionWithoutPrefix = currentVersion.replace(/^v/, '')
                auto.logger.verbose.info("Updating VERSION file to: ", versionWithoutPrefix);
                fs.writeFileSync('./VERSION', versionWithoutPrefix);
                await execPromise("git", ["add", "VERSION"]);
            }
        );
    }
};