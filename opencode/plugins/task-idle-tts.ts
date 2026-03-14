import type { Plugin } from "@opencode-ai/plugin"

const scriptPath = "/Users/jindantong/WorkSpace/dotfiles/scripts/task-completed-tts.sh"

export const SessionIdleTTS: Plugin = async (ctx) => {
  return {
    event: async ({ event }) => {
      if (event.type !== "session.idle") {
        return
      }

      const result = await ctx.$`${scriptPath}`.quiet().nothrow()
      if (result.exitCode !== 0) {
        console.error("[session-idle-tts] failed to run TTS script")
      }
    },
  }
}
