Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C725F13C905
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987406; cv=none; b=OWVmgXoj/JQwZphiEB8l6u8hunxtN1WGihxkGXsTej7s4ImU9jbUVHmOqNB5hXbI5Ct8ossk8hn2K53jISmyiE7ZDxaA9378hp0f3PzikvNBbnLlTp1y19XTKGe/Uz5qUJRzYJC/1sS4tRd3i/eIR5N49+HkI2Evz8Vctjic5IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987406; c=relaxed/simple;
	bh=XogvFA/DLNSVBuacPByJTvpG74GR4VVYAVSGi3gUoNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JP+zR9lrIIHvc5KtQ5C9hn4nPW9uHEkngj2XBf8sZOc6Q7gkkr/THfzNLAQcOqYxYPDPEKrlygFEE7jG7aO30y0QEKGWXneezBE3Qwnrj6bA8p1Xyt3MknCgChL0rymRMkzu0hM1GaIbEJOUe7yvuwCveEM5QF7Iv4VgPBYbS4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EywdM0+/; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EywdM0+/"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-8036ce660e5so151738739f.1
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 13:03:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987404; x=1721592204; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rlJ/V/wOwxb498W/kuhpVKqR9woO92My18vQsEfkf7s=;
        b=EywdM0+/wk5+S2O8HGImCONmaAOyAub2+IRTtQNZnH+rjWjIMCZclw8KMALvlAh9nX
         DYXXsec3rNEWDyLjxZXpuOHIDP5m2pGz+PWiqyFgB85AgIAn2QYpfGSk0LngWwyw+Gn1
         BZgL+2kbN9mqbPb2eqHaO0bjlVIP4U8CMx19qSW9VqZdxG1XPbzQPyupfLsfpfiqsaiz
         jCQvsGOAg29j8GFAJPxGkil4vjGyIHuxx3MP6ZDQAceDRNtbqPpPCtqksmsupOuJFm9W
         +oKOhR389teNRZKhyFfcSOqge1BaR1t0Hr5Di3YrrSev7UYN/JVneWQww32kND9PZubZ
         nQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987404; x=1721592204;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rlJ/V/wOwxb498W/kuhpVKqR9woO92My18vQsEfkf7s=;
        b=nddUghTPIm8pe4PkCqCMoCpatjlErR3zdBgOVoQdfRIpPSciGNLEb3H6SmxtaBb6hI
         OC/rHOp7UJyU0kCGRw/NazluP7P5zK5awQmhSk8gVDuU3GGUXb0vdid6un3k+qvTSK3G
         b+O0Q9PsOjMYlH+pd/yetdrbvZHA+xmvQZs/2jx8v7vHjlh7Qvw8y4gCi+66YQqh4weG
         7O8iXIirZ03oUjEOTx84I8OMfOSHjrCgfx4YDPRvwr2Iz2cqAW+6qZ3aNL1Dlf3hphxU
         WRTgzbpHgnzRQtIj0Taz59ZoyML98HRVZVQ4INtZrI5m/2Qx0eC9xM+QApQclKY7hdCl
         5skg==
X-Forwarded-Encrypted: i=1; AJvYcCXI3Wld0FcBp8e/ynDWMDdtcF3V8XMmdBG3p6xha/WdzS5551dAZuKFQIzh71+RVpd5/xrY4HppfYEuEVJHTE4lPPHHv/GuFe+FlRH0aR0=
X-Gm-Message-State: AOJu0YwGbG+evtFDWrfFD9gJl2xnpIlGujDSB5OZcdQC0xpttOhxSbw8
	SmfmaMcIeaw7zj2eMGv4ScNkpuaj+rI3T8Mml0fni3v1GU2hepXr
X-Google-Smtp-Source: AGHT+IFyuqDw0sZYHIdNrLHMKsDdeepJrIHNcUas0XVpQwA4cj7hkcZ7QvRP7now4DLdDxe/YffRzg==
X-Received: by 2002:a5e:df45:0:b0:7fc:89ed:c17e with SMTP id ca18e2360f4ac-7ffffe21316mr1995524739f.12.1720987403061;
        Sun, 14 Jul 2024 13:03:23 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b2cfb8sm892815173.62.2024.07.14.13.03.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:03:22 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 4/5] introduce "debug" command and "dump" subcommand
Date: Sun, 14 Jul 2024 14:02:25 -0600
Message-ID: <20240714200226.746471-5-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240714200226.746471-1-tahbertschinger@gmail.com>
References: <20240714200226.746471-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This introduces a new command, "debug", that is used for directly
manipulating bkeys in the underlying btrees.

It has a subcommand, "dump", which takes a btree and bpos and
prints the data from that bkey.

For example:

$ bcachefs debug ~/test-img -c "dump inodes 0:4096:U32_MAX"
u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:   mode=40755
  flags= (16300000)
  journal_seq=9
  ...

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 c_src/bcachefs.c             |   4 +-
 c_src/cmd_debug.c            |  38 ++++++++++++
 c_src/cmds.h                 |   2 +
 src/bcachefs.rs              |   1 +
 src/commands/debug/mod.rs    | 108 +++++++++++++++++++++++++++++++++++
 src/commands/debug/parser.rs |  57 ++++++++++++++++++
 src/commands/mod.rs          |   1 +
 7 files changed, 210 insertions(+), 1 deletion(-)
 create mode 100644 c_src/cmd_debug.c
 create mode 100644 src/commands/debug/parser.rs

diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
index c5b61097..311de278 100644
--- a/c_src/bcachefs.c
+++ b/c_src/bcachefs.c
@@ -86,6 +86,7 @@ void bcachefs_usage(void)
 	     "\n"
 	     "Debug:\n"
 	     "These commands work on offline, unmounted filesystems\n"
+	     "  debug                    Operate directly on the underlying btrees of a filesystem\n"
 	     "  dump                     Dump filesystem metadata to a qcow2 image\n"
 	     "  list                     List filesystem metadata in textual form\n"
 	     "  list_journal             List contents of journal\n"
@@ -94,7 +95,8 @@ void bcachefs_usage(void)
 	     "  fusemount                Mount a filesystem via FUSE\n"
 	     "\n"
 	     "Miscellaneous:\n"
-         "  completions              Generate shell completions\n"
+	     "  completions              Generate shell completions\n"
+	     "  list_bkeys               List all bkey types known to the current bcachefs version\n"
 	     "  version                  Display the version of the invoked bcachefs tool\n");
 }
 
diff --git a/c_src/cmd_debug.c b/c_src/cmd_debug.c
new file mode 100644
index 00000000..73ba3995
--- /dev/null
+++ b/c_src/cmd_debug.c
@@ -0,0 +1,38 @@
+#include <stdio.h>
+
+#include "libbcachefs/bkey_types.h"
+#include "libbcachefs/btree_update.h"
+#include "libbcachefs/printbuf.h"
+
+#include "cmds.h"
+
+int cmd_dump_bkey(struct bch_fs *c, enum btree_id id, struct bpos pos)
+{
+	struct btree_trans *trans = bch2_trans_get(c);
+	struct btree_iter iter = { NULL };
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	bch2_trans_iter_init(trans, &iter, id, pos, BTREE_ITER_all_snapshots);
+
+	struct bkey_s_c k = bch2_btree_iter_peek(&iter);
+	if ((ret = bkey_err(k))) {
+		fprintf(stderr, "bch2_btree_iter_peek() failed: %s\n", bch2_err_str(ret));
+		goto out;
+	}
+	if (!k.k || !bpos_eq(pos, k.k->p)) {
+		bch2_bpos_to_text(&buf, pos);
+		printf("no key at pos %s\n", buf.buf);
+		ret = 1;
+		goto out;
+	}
+
+	bch2_bkey_val_to_text(&buf, c, k);
+	printf("%s\n", buf.buf);
+
+out:
+	bch2_trans_iter_exit(trans, &iter);
+	bch2_trans_put(trans);
+
+	return ret;
+}
diff --git a/c_src/cmds.h b/c_src/cmds.h
index 64267dc4..d55a1440 100644
--- a/c_src/cmds.h
+++ b/c_src/cmds.h
@@ -54,6 +54,8 @@ int cmd_subvolume_snapshot(int argc, char *argv[]);
 
 int cmd_fusemount(int argc, char *argv[]);
 
+int cmd_dump_bkey(struct bch_fs *, enum btree_id, struct bpos);
+
 void bcachefs_usage(void);
 int device_cmds(int argc, char *argv[]);
 int fs_cmds(int argc, char *argv[]);
diff --git a/src/bcachefs.rs b/src/bcachefs.rs
index 4b8cef49..0087334d 100644
--- a/src/bcachefs.rs
+++ b/src/bcachefs.rs
@@ -102,6 +102,7 @@ fn main() -> ExitCode {
     };
 
     match cmd {
+        "debug" => commands::debug(args[1..].to_vec()).report(),
         "completions" => {
             commands::completions(args[1..].to_vec());
             ExitCode::SUCCESS
diff --git a/src/commands/debug/mod.rs b/src/commands/debug/mod.rs
index 30ffd16b..31b23c7e 100644
--- a/src/commands/debug/mod.rs
+++ b/src/commands/debug/mod.rs
@@ -1,7 +1,115 @@
+use clap::Parser;
+use std::io::{BufRead, Write};
+
+use bch_bindgen::bcachefs;
+use bch_bindgen::c;
+use bch_bindgen::fs::Fs;
+
 mod bkey_types;
+mod parser;
+
+use bch_bindgen::c::bpos;
 
 use anyhow::Result;
 
+/// Debug a bcachefs filesystem.
+#[derive(Parser, Debug)]
+pub struct Cli {
+    #[arg(required(true))]
+    devices: Vec<std::path::PathBuf>,
+
+    #[arg(short, long)]
+    command: Option<String>,
+}
+
+#[derive(Debug)]
+enum DebugCommand {
+    Dump(DumpCommand),
+}
+
+#[derive(Debug)]
+struct DumpCommand {
+    btree: String,
+    bpos: bpos,
+}
+
+fn dump(fs: &Fs, cmd: DumpCommand) {
+    let id: bch_bindgen::c::btree_id = match cmd.btree.parse() {
+        Ok(b) => b,
+        Err(_) => {
+            eprintln!("unknown btree '{}'", cmd.btree);
+            return;
+        }
+    };
+
+    unsafe {
+        c::cmd_dump_bkey(fs.raw, id, cmd.bpos);
+    }
+}
+
+fn usage() {
+    println!("Usage:");
+    println!("    dump <btree_type> <bpos>");
+}
+
+fn do_command(fs: &Fs, cmd: &str) -> i32 {
+    match parser::parse_command(cmd) {
+        Ok(cmd) => {
+            match cmd {
+                DebugCommand::Dump(cmd) => dump(fs, cmd),
+            };
+
+            0
+        }
+        Err(e) => {
+            println!("{e}");
+            usage();
+
+            1
+        }
+    }
+}
+
+pub fn debug(argv: Vec<String>) -> Result<()> {
+    fn prompt() {
+        print!("bcachefs> ");
+        std::io::stdout().flush().unwrap();
+    }
+
+    let opt = Cli::parse_from(argv);
+    let fs_opts: bcachefs::bch_opts = Default::default();
+
+    if let Some(cmd) = opt.command {
+        return match parser::parse_command(&cmd) {
+            Ok(cmd) => {
+                let fs = Fs::open(&opt.devices, fs_opts)?;
+                match cmd {
+                    DebugCommand::Dump(cmd) => dump(&fs, cmd),
+                }
+
+                Ok(())
+            }
+            Err(e) => {
+                println!("{e}");
+                usage();
+
+                Ok(())
+            }
+        };
+    }
+
+    let fs = Fs::open(&opt.devices, fs_opts)?;
+
+    prompt();
+    let stdin = std::io::stdin();
+    for line in stdin.lock().lines() {
+        do_command(&fs, &line.unwrap());
+        prompt();
+    }
+
+    Ok(())
+}
+
 pub fn list_bkeys() -> Result<()> {
     print!("{}", bkey_types::get_bkey_type_info()?);
 
diff --git a/src/commands/debug/parser.rs b/src/commands/debug/parser.rs
new file mode 100644
index 00000000..fa036447
--- /dev/null
+++ b/src/commands/debug/parser.rs
@@ -0,0 +1,57 @@
+use nom::branch::alt;
+use nom::bytes::complete::tag;
+use nom::character::complete::{alpha1, char, space1, u32, u64};
+use nom::combinator::{all_consuming, value};
+use nom::sequence::tuple;
+use nom::IResult;
+
+use bch_bindgen::c::bpos;
+
+use crate::commands::debug::{DebugCommand, DumpCommand};
+
+fn parse_bpos(input: &str) -> IResult<&str, bpos> {
+    let (input, (inode, _, offset, _, snapshot)) = tuple((
+        u64,
+        char(':'),
+        u64,
+        char(':'),
+        alt((u32, value(u32::MAX, tag("U32_MAX")))),
+    ))(input)?;
+
+    Ok((
+        input,
+        bpos {
+            inode,
+            offset,
+            snapshot,
+        },
+    ))
+}
+
+fn parse_dump_cmd(input: &str) -> IResult<&str, DebugCommand> {
+    let (input, (_, btree, _, bpos)) =
+        all_consuming(tuple((space1, alpha1, space1, parse_bpos)))(input)?;
+
+    Ok((
+        input,
+        DebugCommand::Dump(DumpCommand {
+            btree: btree.to_string(),
+            bpos,
+        }),
+    ))
+}
+
+fn parse_command_inner(input: &str) -> IResult<&str, DebugCommand> {
+    let (input, _) = tag("dump")(input)?;
+
+    parse_dump_cmd(input)
+}
+
+/// Given an input string, tries to parse it into a valid
+/// command to the debug tool.
+pub fn parse_command(input: &str) -> anyhow::Result<DebugCommand> {
+    match parse_command_inner(input) {
+        Ok((_, c)) => Ok(c),
+        Err(e) => Err(anyhow::anyhow!("{e}")),
+    }
+}
diff --git a/src/commands/mod.rs b/src/commands/mod.rs
index 9365f981..425e0849 100644
--- a/src/commands/mod.rs
+++ b/src/commands/mod.rs
@@ -7,6 +7,7 @@ pub mod mount;
 pub mod subvolume;
 
 pub use completions::completions;
+pub use debug::debug;
 pub use debug::list_bkeys;
 pub use list::list;
 pub use mount::mount;
-- 
2.45.2

