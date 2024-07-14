Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5098413CF9E
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720988362; cv=none; b=iuQeIH28sxT6Vf14pV52z/ZrZJgu1hrQMWbxr38nghDcodJTL0OueUv9UzFkLzmWz6ZbDDdX2Nr6aZkHI85n9h3Td8auHPQaxYeDaBAadSWHz1Dh2YmTEKEppx9/nPEajX6LUtENuX4ACOLmMAkO7uAEm/GIF3I0iq2Tyb4mnEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720988362; c=relaxed/simple;
	bh=/+0+1FpfO4arVe0/9wvB9GdKoKcVlIZD5PF/K0JkT/U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ItdoBOxOqcLyNrdX9Q88nICRugVWe7FdtQyUDhcriG27+r4YMxufxE7aBdfrIVut/O1gMvPOIGCUZttL50TMn5p4i4klFec70dol1We9Yz2cq/7M46sC1Fb3hDKg26wxU/F/aqV1hCkgji4PmXKF3UJhbXj1EaWwDyiP3gH8lVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=t9inq2y8; arc=none smtp.client-ip=91.218.175.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="t9inq2y8"
X-Envelope-To: tahbertschinger@gmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1720988357;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=QNTQD5n79GAaL0zS42Am7PJE0vqCvBu4FDy4H44235s=;
	b=t9inq2y8OOBVkBIdQI4djY7kDWHZizmiQJX5VXpyZ2/c4/9AKFx7uI7zy90Gd8o2cjdod+
	D/fkww4Syd7xycJzaRvFecD6YuFc6H3bmxBhG4FbM5/hyGIKqR/zJRNhccaxJ1JuZRLAhV
	atQyC/fFeTkIBMEPXTMNe9z+wokL53E=
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: bfoster@redhat.com
Date: Sun, 14 Jul 2024 16:19:14 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Thomas Bertschinger <tahbertschinger@gmail.com>
Cc: linux-bcachefs@vger.kernel.org, bfoster@redhat.com
Subject: Re: [PATCH TOOLS v2 4/5] introduce "debug" command and "dump"
 subcommand
Message-ID: <aafvxbrmhfsqn3bkcsd3ytyool4qkgmewlfk6dtianyk5wl5dd@iksq7uypymdx>
References: <20240714200226.746471-1-tahbertschinger@gmail.com>
 <20240714200226.746471-5-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240714200226.746471-5-tahbertschinger@gmail.com>
X-Migadu-Flow: FLOW_OUT

On Sun, Jul 14, 2024 at 02:02:25PM GMT, Thomas Bertschinger wrote:
> This introduces a new command, "debug", that is used for directly
> manipulating bkeys in the underlying btrees.
> 
> It has a subcommand, "dump", which takes a btree and bpos and
> prints the data from that bkey.

But we already have that functionality - the 'list' subcommand...

Did you just want an easy way to print a single key?

> 
> For example:
> 
> $ bcachefs debug ~/test-img -c "dump inodes 0:4096:U32_MAX"
> u64s 17 type inode_v3 0:4096:U32_MAX len 0 ver 0:   mode=40755
>   flags= (16300000)
>   journal_seq=9
>   ...
> 
> Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
> ---
>  c_src/bcachefs.c             |   4 +-
>  c_src/cmd_debug.c            |  38 ++++++++++++
>  c_src/cmds.h                 |   2 +
>  src/bcachefs.rs              |   1 +
>  src/commands/debug/mod.rs    | 108 +++++++++++++++++++++++++++++++++++
>  src/commands/debug/parser.rs |  57 ++++++++++++++++++
>  src/commands/mod.rs          |   1 +
>  7 files changed, 210 insertions(+), 1 deletion(-)
>  create mode 100644 c_src/cmd_debug.c
>  create mode 100644 src/commands/debug/parser.rs
> 
> diff --git a/c_src/bcachefs.c b/c_src/bcachefs.c
> index c5b61097..311de278 100644
> --- a/c_src/bcachefs.c
> +++ b/c_src/bcachefs.c
> @@ -86,6 +86,7 @@ void bcachefs_usage(void)
>  	     "\n"
>  	     "Debug:\n"
>  	     "These commands work on offline, unmounted filesystems\n"
> +	     "  debug                    Operate directly on the underlying btrees of a filesystem\n"
>  	     "  dump                     Dump filesystem metadata to a qcow2 image\n"
>  	     "  list                     List filesystem metadata in textual form\n"
>  	     "  list_journal             List contents of journal\n"
> @@ -94,7 +95,8 @@ void bcachefs_usage(void)
>  	     "  fusemount                Mount a filesystem via FUSE\n"
>  	     "\n"
>  	     "Miscellaneous:\n"
> -         "  completions              Generate shell completions\n"
> +	     "  completions              Generate shell completions\n"
> +	     "  list_bkeys               List all bkey types known to the current bcachefs version\n"
>  	     "  version                  Display the version of the invoked bcachefs tool\n");
>  }
>  
> diff --git a/c_src/cmd_debug.c b/c_src/cmd_debug.c
> new file mode 100644
> index 00000000..73ba3995
> --- /dev/null
> +++ b/c_src/cmd_debug.c
> @@ -0,0 +1,38 @@
> +#include <stdio.h>
> +
> +#include "libbcachefs/bkey_types.h"
> +#include "libbcachefs/btree_update.h"
> +#include "libbcachefs/printbuf.h"
> +
> +#include "cmds.h"
> +
> +int cmd_dump_bkey(struct bch_fs *c, enum btree_id id, struct bpos pos)
> +{
> +	struct btree_trans *trans = bch2_trans_get(c);
> +	struct btree_iter iter = { NULL };
> +	struct printbuf buf = PRINTBUF;
> +	int ret = 0;
> +
> +	bch2_trans_iter_init(trans, &iter, id, pos, BTREE_ITER_all_snapshots);
> +
> +	struct bkey_s_c k = bch2_btree_iter_peek(&iter);
> +	if ((ret = bkey_err(k))) {
> +		fprintf(stderr, "bch2_btree_iter_peek() failed: %s\n", bch2_err_str(ret));
> +		goto out;
> +	}
> +	if (!k.k || !bpos_eq(pos, k.k->p)) {
> +		bch2_bpos_to_text(&buf, pos);
> +		printf("no key at pos %s\n", buf.buf);
> +		ret = 1;
> +		goto out;
> +	}
> +
> +	bch2_bkey_val_to_text(&buf, c, k);
> +	printf("%s\n", buf.buf);
> +
> +out:
> +	bch2_trans_iter_exit(trans, &iter);
> +	bch2_trans_put(trans);
> +
> +	return ret;
> +}
> diff --git a/c_src/cmds.h b/c_src/cmds.h
> index 64267dc4..d55a1440 100644
> --- a/c_src/cmds.h
> +++ b/c_src/cmds.h
> @@ -54,6 +54,8 @@ int cmd_subvolume_snapshot(int argc, char *argv[]);
>  
>  int cmd_fusemount(int argc, char *argv[]);
>  
> +int cmd_dump_bkey(struct bch_fs *, enum btree_id, struct bpos);
> +
>  void bcachefs_usage(void);
>  int device_cmds(int argc, char *argv[]);
>  int fs_cmds(int argc, char *argv[]);
> diff --git a/src/bcachefs.rs b/src/bcachefs.rs
> index 4b8cef49..0087334d 100644
> --- a/src/bcachefs.rs
> +++ b/src/bcachefs.rs
> @@ -102,6 +102,7 @@ fn main() -> ExitCode {
>      };
>  
>      match cmd {
> +        "debug" => commands::debug(args[1..].to_vec()).report(),
>          "completions" => {
>              commands::completions(args[1..].to_vec());
>              ExitCode::SUCCESS
> diff --git a/src/commands/debug/mod.rs b/src/commands/debug/mod.rs
> index 30ffd16b..31b23c7e 100644
> --- a/src/commands/debug/mod.rs
> +++ b/src/commands/debug/mod.rs
> @@ -1,7 +1,115 @@
> +use clap::Parser;
> +use std::io::{BufRead, Write};
> +
> +use bch_bindgen::bcachefs;
> +use bch_bindgen::c;
> +use bch_bindgen::fs::Fs;
> +
>  mod bkey_types;
> +mod parser;
> +
> +use bch_bindgen::c::bpos;
>  
>  use anyhow::Result;
>  
> +/// Debug a bcachefs filesystem.
> +#[derive(Parser, Debug)]
> +pub struct Cli {
> +    #[arg(required(true))]
> +    devices: Vec<std::path::PathBuf>,
> +
> +    #[arg(short, long)]
> +    command: Option<String>,
> +}
> +
> +#[derive(Debug)]
> +enum DebugCommand {
> +    Dump(DumpCommand),
> +}
> +
> +#[derive(Debug)]
> +struct DumpCommand {
> +    btree: String,
> +    bpos: bpos,
> +}
> +
> +fn dump(fs: &Fs, cmd: DumpCommand) {
> +    let id: bch_bindgen::c::btree_id = match cmd.btree.parse() {
> +        Ok(b) => b,
> +        Err(_) => {
> +            eprintln!("unknown btree '{}'", cmd.btree);
> +            return;
> +        }
> +    };
> +
> +    unsafe {
> +        c::cmd_dump_bkey(fs.raw, id, cmd.bpos);
> +    }
> +}
> +
> +fn usage() {
> +    println!("Usage:");
> +    println!("    dump <btree_type> <bpos>");
> +}
> +
> +fn do_command(fs: &Fs, cmd: &str) -> i32 {
> +    match parser::parse_command(cmd) {
> +        Ok(cmd) => {
> +            match cmd {
> +                DebugCommand::Dump(cmd) => dump(fs, cmd),
> +            };
> +
> +            0
> +        }
> +        Err(e) => {
> +            println!("{e}");
> +            usage();
> +
> +            1
> +        }
> +    }
> +}
> +
> +pub fn debug(argv: Vec<String>) -> Result<()> {
> +    fn prompt() {
> +        print!("bcachefs> ");
> +        std::io::stdout().flush().unwrap();
> +    }
> +
> +    let opt = Cli::parse_from(argv);
> +    let fs_opts: bcachefs::bch_opts = Default::default();
> +
> +    if let Some(cmd) = opt.command {
> +        return match parser::parse_command(&cmd) {
> +            Ok(cmd) => {
> +                let fs = Fs::open(&opt.devices, fs_opts)?;
> +                match cmd {
> +                    DebugCommand::Dump(cmd) => dump(&fs, cmd),
> +                }
> +
> +                Ok(())
> +            }
> +            Err(e) => {
> +                println!("{e}");
> +                usage();
> +
> +                Ok(())
> +            }
> +        };
> +    }
> +
> +    let fs = Fs::open(&opt.devices, fs_opts)?;
> +
> +    prompt();
> +    let stdin = std::io::stdin();
> +    for line in stdin.lock().lines() {
> +        do_command(&fs, &line.unwrap());
> +        prompt();
> +    }
> +
> +    Ok(())
> +}
> +
>  pub fn list_bkeys() -> Result<()> {
>      print!("{}", bkey_types::get_bkey_type_info()?);
>  
> diff --git a/src/commands/debug/parser.rs b/src/commands/debug/parser.rs
> new file mode 100644
> index 00000000..fa036447
> --- /dev/null
> +++ b/src/commands/debug/parser.rs
> @@ -0,0 +1,57 @@
> +use nom::branch::alt;
> +use nom::bytes::complete::tag;
> +use nom::character::complete::{alpha1, char, space1, u32, u64};
> +use nom::combinator::{all_consuming, value};
> +use nom::sequence::tuple;
> +use nom::IResult;
> +
> +use bch_bindgen::c::bpos;
> +
> +use crate::commands::debug::{DebugCommand, DumpCommand};
> +
> +fn parse_bpos(input: &str) -> IResult<&str, bpos> {
> +    let (input, (inode, _, offset, _, snapshot)) = tuple((
> +        u64,
> +        char(':'),
> +        u64,
> +        char(':'),
> +        alt((u32, value(u32::MAX, tag("U32_MAX")))),
> +    ))(input)?;
> +
> +    Ok((
> +        input,
> +        bpos {
> +            inode,
> +            offset,
> +            snapshot,
> +        },
> +    ))
> +}
> +
> +fn parse_dump_cmd(input: &str) -> IResult<&str, DebugCommand> {
> +    let (input, (_, btree, _, bpos)) =
> +        all_consuming(tuple((space1, alpha1, space1, parse_bpos)))(input)?;
> +
> +    Ok((
> +        input,
> +        DebugCommand::Dump(DumpCommand {
> +            btree: btree.to_string(),
> +            bpos,
> +        }),
> +    ))
> +}
> +
> +fn parse_command_inner(input: &str) -> IResult<&str, DebugCommand> {
> +    let (input, _) = tag("dump")(input)?;
> +
> +    parse_dump_cmd(input)
> +}
> +
> +/// Given an input string, tries to parse it into a valid
> +/// command to the debug tool.
> +pub fn parse_command(input: &str) -> anyhow::Result<DebugCommand> {
> +    match parse_command_inner(input) {
> +        Ok((_, c)) => Ok(c),
> +        Err(e) => Err(anyhow::anyhow!("{e}")),
> +    }
> +}
> diff --git a/src/commands/mod.rs b/src/commands/mod.rs
> index 9365f981..425e0849 100644
> --- a/src/commands/mod.rs
> +++ b/src/commands/mod.rs
> @@ -7,6 +7,7 @@ pub mod mount;
>  pub mod subvolume;
>  
>  pub use completions::completions;
> +pub use debug::debug;
>  pub use debug::list_bkeys;
>  pub use list::list;
>  pub use mount::mount;
> -- 
> 2.45.2
> 
