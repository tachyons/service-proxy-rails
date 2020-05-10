const fs = require('fs');
const execPromise = require('@auto-it/core').execPromise;
const inc = require('semver').inc;

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
                let version
                if (lastRelease.match(/\d+\.\d+\.\d+/)) {
                    version = await auto.release.calcNextVersion(lastRelease);
                } else {
                    // lastRelease is a git sha. no releases have been made
                    const bump = await auto.release.getSemverBump(lastRelease);
                    version = inc(currentVersion, bump);
                }

                auto.logger.verbose.error(`!!! in beforeCommitChangelog, currentVersion: ${currentVersion}, commits: ${commits}, notes: ${releaseNotes}, lastRelease: ${lastRelease}, version: ${version}`)
                const versionWithoutPrefix = version.replace(/^v/, '')
                auto.logger.verbose.error("Updating VERSION file to: ", versionWithoutPrefix);
                fs.writeFileSync('./VERSION', versionWithoutPrefix);
                await execPromise("git", ["add", "VERSION"]);
            }
        );
    }
};