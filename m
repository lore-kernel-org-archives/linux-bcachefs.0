Received: from mail-io1-f44.google.com (mail-io1-f44.google.com [209.85.166.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6131813C904
	for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 20:03:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720987410; cv=none; b=oA9hPBZfWDSQkrZ9vgLX0Xy3vDISdIJb5Qs5mxiaKaESH5G34uyrl0fXxro8E9RexGKPT5feavY7CgnaF4WlsLufISeDkDykT/93gBh66Mh/2/qxKP5Ykbg3JcXSkWx5rgiNk785daFp0rd1lwXouklL0tBW+pEjZoHFC1eu3xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720987410; c=relaxed/simple;
	bh=YhwOXlXIx49KqCbFkLz/uW6nfh9vlrwQCz7ryClx9q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dFCyUftf9SarS9ok9zEa1JYXYsYrEqTdQCVtKON1n2+oeaf2+23tCow0WxigWGA6692j2WmvINpZtegWtoP+L33wHywG/zsN2iyqoRfAk0k74Zm1SeWOmjjShm3mcyC5MftwpqOSnNjLfncg7DsIh3VEm4mkokiCB6JymdKKHwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WPzmSA4f; arc=none smtp.client-ip=209.85.166.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WPzmSA4f"
Received: by mail-io1-f44.google.com with SMTP id ca18e2360f4ac-7fd3dbc01deso175131339f.0
        for <linux-bcachefs@vger.kernel.org>; Sun, 14 Jul 2024 13:03:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720987407; x=1721592207; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZR8Cl0pqwnH12Oa/ui9a8p+gKbrDIblmpPdU0BUYso=;
        b=WPzmSA4flsZE9LW8QLNvPdKFg+RB/JMMMpASbkXFI06SiJw9b2iNv+cCxx3n1ZRXD4
         8vfB91txffaRyoAlWBbwxIYPZkIc018PdJTTZzRnpcnytSKGzveZwHH1Jrc5DX7xt7Ah
         RQzpZtJMZLChBdLu9Qws3PtD0arpAh/+uZcVCnb34OonfDMHvtPBqODXQ0utCw/DTy5o
         DKj4/zkRhSnMHr1RWmbUFhDiQGm7ERR4U7d2SikwZlWMCJS7pPhLnp5+DgznElRKgzNL
         /7krnjwWVfhlnWeM2k5Flf7GPi46PLW76E3Btfkksjo25GWd16Dezeab6MNDbdOZcXiA
         xKIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720987407; x=1721592207;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7ZR8Cl0pqwnH12Oa/ui9a8p+gKbrDIblmpPdU0BUYso=;
        b=U2U3+aSVpt7dhVGLHgpnlicT3mSSxEYa/PlRfpkC6a7fAqum3vihd/7QhXPaRc2wb4
         9SGFvwP83nh+M3vfQZTd8BvEZXkpoTf8xVyISZypQRoFrIEpFggPhPEOSlIPouWWwUwd
         YNR7NKembMo4iJ6byC8dfKiGTOLUBbJoLb3XKOQUKdTkG2yBQLlmr3mzE4nZ0aHO00Sq
         LQIPtU/GeXQ8Uj8a1nnA2d4dOOWlxNdaIMieOmzGIVPLDzkf9hn5pC2AJmP8f3QnZBkS
         8WwaTtQsCi8WE9utPTxUTMibJr5T8ib03zRqlnTF60OygoGgwNQGFpdolUIaYl7ZUth7
         qxUA==
X-Forwarded-Encrypted: i=1; AJvYcCXAfn57ZHoV5Rsw2YvOOVlt8JZdrA6MAy+LyiYxNtIpFs8jgecUjAC/2ZVr98Bp3lpMnHleSYy39fvgoyoRqRGEc+e7yzcarW1jtvk/MxI=
X-Gm-Message-State: AOJu0Yx/sK34erhEW0gKLPtBEu1qXWxGd0R3u6P0miUwauaMXEbk/3cP
	a5M6s2WFrI5XMDiaOLUsYE33zMZMJY2OXew6zAHVgRQfvCPc5Ywp
X-Google-Smtp-Source: AGHT+IGgVcMdxtOPM3yaDiVbmXlzfE3GOVM/t4ab3nAjaGAgb4sRH8t2290S54QetV8def103cAHgQ==
X-Received: by 2002:a6b:f70c:0:b0:7fa:ef21:da0a with SMTP id ca18e2360f4ac-800034fd55bmr1823357739f.14.1720987407486;
        Sun, 14 Jul 2024 13:03:27 -0700 (PDT)
Received: from fedora-laptop.hsd1.nm.comcast.net ([2601:8c1:c100:1c70:46d4:8434:9d74:6efc])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c1e1b2cfb8sm892815173.62.2024.07.14.13.03.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jul 2024 13:03:27 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 5/5] introduce new "debug update" command
Date: Sun, 14 Jul 2024 14:02:26 -0600
Message-ID: <20240714200226.746471-6-tahbertschinger@gmail.com>
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

This introduces a new subcommand, "update", which is used to update a
given field of a key to a value. For example:

$ bcachefs debug ~/test-img -c "update inodes 0:4096:U32_MAX bch_inode_unpacked.bi_nlink=35"

$ bcachefs debug ~/test-img -c "dump inodes 0:4096:U32_MAX" | grep nlink
  bi_nlink=35

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 c_src/cmd_debug.c                | 107 +++++++++++++++++++++++++++++++
 c_src/cmds.h                     |  16 +++++
 src/commands/debug/bkey_types.rs |  20 ++++++
 src/commands/debug/mod.rs        |  62 +++++++++++++++++-
 src/commands/debug/parser.rs     |  58 +++++++++++++++--
 5 files changed, 255 insertions(+), 8 deletions(-)

diff --git a/c_src/cmd_debug.c b/c_src/cmd_debug.c
index 73ba3995..9eec1ddb 100644
--- a/c_src/cmd_debug.c
+++ b/c_src/cmd_debug.c
@@ -3,9 +3,41 @@
 #include "libbcachefs/bkey_types.h"
 #include "libbcachefs/btree_update.h"
 #include "libbcachefs/printbuf.h"
+#include "libbcachefs/inode.h"
 
 #include "cmds.h"
 
+void write_field(enum bkey_update_op op, void *base, u64 size, u64 offset,
+		 u64 value)
+{
+#define x(_size, _bits)								\
+	u##_bits *field_##_bits;						\
+	case _size:								\
+		field_##_bits = (u##_bits *) ((u8 *)base + offset);		\
+		switch (op) {							\
+		case BKEY_CMD_SET:						\
+			*field_##_bits = (u##_bits) value;			\
+			break;							\
+		case BKEY_CMD_ADD:						\
+			*field_##_bits += (u##_bits) value;			\
+			break;							\
+		default:							\
+			fprintf(stderr, "invalid operation: %d\n", op);		\
+			break;							\
+		}								\
+		break;
+
+	switch (size) {
+		x(1, 8)
+		x(2, 16)
+		x(4, 32)
+		x(8, 64)
+	default:
+		fprintf(stderr, "invalid size: %llu\n", size);
+	}
+#undef x
+}
+
 int cmd_dump_bkey(struct bch_fs *c, enum btree_id id, struct bpos pos)
 {
 	struct btree_trans *trans = bch2_trans_get(c);
@@ -36,3 +68,78 @@ out:
 
 	return ret;
 }
+
+int cmd_update_bkey(struct bch_fs *c, struct bkey_update u, struct bpos pos)
+{
+	struct btree_trans *trans = bch2_trans_get(c);
+	struct btree_iter iter = { NULL };
+	struct printbuf buf = PRINTBUF;
+	int ret = 0;
+
+	set_bit(BCH_FS_no_invalid_checks, &c->flags);
+
+	bch2_trans_iter_init(trans, &iter, u.id, pos, BTREE_ITER_all_snapshots);
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
+	if (u.inode_unpacked) {
+		if (k.k->type != KEY_TYPE_inode_v2 && k.k->type != KEY_TYPE_inode_v3) {
+			fprintf(stderr, "Wanted bch_inode_unpacked, got 'bch_%s'\n",
+				bch2_bkey_types[k.k->type]);
+			goto out;
+		}
+
+		struct bch_inode_unpacked inode;
+		ret = bch2_inode_unpack(k, &inode);
+		if (ret != 0) {
+			fprintf(stderr, "bch2_inode_unpack() failed: %s\n", bch2_err_str(ret));
+			goto out;
+		}
+
+		write_field(u.op, &inode, u.size, u.offset, u.value);
+
+		ret = bch2_inode_write(trans, &iter, &inode) ?:
+		      bch2_trans_commit(trans, NULL, NULL, 0);
+		if (ret != 0) {
+			fprintf(stderr, "inode update failed: %s\n", bch2_err_str(ret));
+		}
+	} else {
+		if (u.bkey != k.k->type) {
+			fprintf(stderr, "Wanted type 'bch_%s', got type 'bch_%s'\n",
+				bch2_bkey_types[u.bkey], bch2_bkey_types[k.k->type]);
+			goto out;
+		}
+
+		bch2_trans_unlock(trans);
+
+		struct bkey_i *n = bch2_bkey_make_mut_noupdate(trans, k);
+		if ((ret = PTR_ERR_OR_ZERO(n))) {
+			fprintf(stderr, "bch2_bkey_make_mut_noupdate() failed: %s\n",
+				bch2_err_str(ret));
+			goto out;
+		}
+
+		write_field(u.op, &n->v, u.size, u.offset, u.value);
+
+		ret = bch2_btree_insert(c, u.id, n, NULL, 0, 0);
+		if (ret != 0) {
+			fprintf(stderr, "bch2_btree_insert() failed: %s\n", bch2_err_str(ret));
+		}
+	}
+
+out:
+	bch2_trans_iter_exit(trans, &iter);
+	bch2_trans_put(trans);
+
+	return ret;
+}
diff --git a/c_src/cmds.h b/c_src/cmds.h
index d55a1440..8e744e3f 100644
--- a/c_src/cmds.h
+++ b/c_src/cmds.h
@@ -9,6 +9,21 @@
 
 #include "tools-util.h"
 
+enum bkey_update_op {
+	BKEY_CMD_SET,
+	BKEY_CMD_ADD,
+};
+
+struct bkey_update {
+	enum btree_id id;
+	enum bch_bkey_type bkey;
+	enum bkey_update_op op;
+	bool inode_unpacked;
+	u64 offset;
+	u64 size;
+	u64 value;
+};
+
 int cmd_format(int argc, char *argv[]);
 int cmd_show_super(int argc, char *argv[]);
 int cmd_reset_counters(int argc, char *argv[]);
@@ -55,6 +70,7 @@ int cmd_subvolume_snapshot(int argc, char *argv[]);
 int cmd_fusemount(int argc, char *argv[]);
 
 int cmd_dump_bkey(struct bch_fs *, enum btree_id, struct bpos);
+int cmd_update_bkey(struct bch_fs *, struct bkey_update, struct bpos);
 
 void bcachefs_usage(void);
 int device_cmds(int argc, char *argv[]);
diff --git a/src/commands/debug/bkey_types.rs b/src/commands/debug/bkey_types.rs
index 680d4410..9bb39669 100644
--- a/src/commands/debug/bkey_types.rs
+++ b/src/commands/debug/bkey_types.rs
@@ -13,6 +13,15 @@ impl BkeyTypes {
     pub fn new() -> Self {
         BkeyTypes(Vec::new())
     }
+
+    /// Given a struct name and a member name, return the size and offset of
+    /// the member within the struct, or None if it does not exist.
+    pub fn get_member_layout(&self, outer: &str, member: &str) -> Option<(u64, u64)> {
+        self.0
+            .iter()
+            .find(|i| i.name == *outer)
+            .and_then(|i| i.member_layout(member))
+    }
 }
 
 impl std::fmt::Display for BkeyTypes {
@@ -39,6 +48,17 @@ pub struct BchStruct {
     pub members: Vec<BchMember>,
 }
 
+impl BchStruct {
+    /// Given a struct member name, return the size and offset of the member
+    /// within its parent, or None if there is no member with the given name.
+    pub fn member_layout(&self, name: &str) -> Option<(u64, u64)> {
+        self.members
+            .iter()
+            .find(|i| i.name == *name)
+            .map(|i| (i.size, i.offset))
+    }
+}
+
 /// The representation of a struct member. We need its name, size, and offset
 /// within the parent struct.
 #[derive(Debug)]
diff --git a/src/commands/debug/mod.rs b/src/commands/debug/mod.rs
index 31b23c7e..813b80d5 100644
--- a/src/commands/debug/mod.rs
+++ b/src/commands/debug/mod.rs
@@ -8,7 +8,7 @@ use bch_bindgen::fs::Fs;
 mod bkey_types;
 mod parser;
 
-use bch_bindgen::c::bpos;
+use bch_bindgen::c::{bkey_update_op, bpos};
 
 use anyhow::Result;
 
@@ -25,6 +25,7 @@ pub struct Cli {
 #[derive(Debug)]
 enum DebugCommand {
     Dump(DumpCommand),
+    Update(UpdateCommand),
 }
 
 #[derive(Debug)]
@@ -33,6 +34,57 @@ struct DumpCommand {
     bpos: bpos,
 }
 
+#[derive(Debug)]
+struct UpdateCommand {
+    btree: String,
+    bpos: bpos,
+    bkey: String,
+    field: String,
+    op: bkey_update_op,
+    value: u64,
+}
+
+fn update(fs: &Fs, type_list: &bkey_types::BkeyTypes, cmd: UpdateCommand) {
+    let id: bch_bindgen::c::btree_id = match cmd.btree.parse() {
+        Ok(b) => b,
+        Err(_) => {
+            eprintln!("unknown btree '{}'", cmd.btree);
+            return;
+        }
+    };
+
+    let (bkey, inode_unpacked) = if cmd.bkey == "bch_inode_unpacked" {
+        (c::bch_bkey_type::KEY_TYPE_MAX, true)
+    } else {
+        let bkey = match cmd.bkey["bch_".len()..].parse() {
+            Ok(k) => k,
+            Err(_) => {
+                eprintln!("unknown bkey type '{}'", cmd.bkey);
+                return;
+            }
+        };
+
+        (bkey, false)
+    };
+
+    if let Some((size, offset)) = type_list.get_member_layout(&cmd.bkey, &cmd.field) {
+        let update = c::bkey_update {
+            id,
+            bkey,
+            op: cmd.op,
+            inode_unpacked,
+            offset,
+            size,
+            value: cmd.value,
+        };
+        unsafe {
+            c::cmd_update_bkey(fs.raw, update, cmd.bpos);
+        }
+    } else {
+        println!("unknown field '{}'", cmd.field);
+    }
+}
+
 fn dump(fs: &Fs, cmd: DumpCommand) {
     let id: bch_bindgen::c::btree_id = match cmd.btree.parse() {
         Ok(b) => b,
@@ -50,13 +102,15 @@ fn dump(fs: &Fs, cmd: DumpCommand) {
 fn usage() {
     println!("Usage:");
     println!("    dump <btree_type> <bpos>");
+    println!("    update <btree_type> <bpos> <bkey_type>.<field>=<value>");
 }
 
-fn do_command(fs: &Fs, cmd: &str) -> i32 {
+fn do_command(fs: &Fs, type_list: &bkey_types::BkeyTypes, cmd: &str) -> i32 {
     match parser::parse_command(cmd) {
         Ok(cmd) => {
             match cmd {
                 DebugCommand::Dump(cmd) => dump(fs, cmd),
+                DebugCommand::Update(cmd) => update(fs, type_list, cmd),
             };
 
             0
@@ -78,6 +132,7 @@ pub fn debug(argv: Vec<String>) -> Result<()> {
 
     let opt = Cli::parse_from(argv);
     let fs_opts: bcachefs::bch_opts = Default::default();
+    let type_list = bkey_types::get_bkey_type_info()?;
 
     if let Some(cmd) = opt.command {
         return match parser::parse_command(&cmd) {
@@ -85,6 +140,7 @@ pub fn debug(argv: Vec<String>) -> Result<()> {
                 let fs = Fs::open(&opt.devices, fs_opts)?;
                 match cmd {
                     DebugCommand::Dump(cmd) => dump(&fs, cmd),
+                    DebugCommand::Update(cmd) => update(&fs, &type_list, cmd),
                 }
 
                 Ok(())
@@ -103,7 +159,7 @@ pub fn debug(argv: Vec<String>) -> Result<()> {
     prompt();
     let stdin = std::io::stdin();
     for line in stdin.lock().lines() {
-        do_command(&fs, &line.unwrap());
+        do_command(&fs, &type_list, &line.unwrap());
         prompt();
     }
 
diff --git a/src/commands/debug/parser.rs b/src/commands/debug/parser.rs
index fa036447..19adeba7 100644
--- a/src/commands/debug/parser.rs
+++ b/src/commands/debug/parser.rs
@@ -1,13 +1,13 @@
 use nom::branch::alt;
-use nom::bytes::complete::tag;
+use nom::bytes::complete::{tag, take_while};
 use nom::character::complete::{alpha1, char, space1, u32, u64};
 use nom::combinator::{all_consuming, value};
 use nom::sequence::tuple;
 use nom::IResult;
 
-use bch_bindgen::c::bpos;
+use bch_bindgen::c::{bkey_update_op, bpos};
 
-use crate::commands::debug::{DebugCommand, DumpCommand};
+use crate::commands::debug::{DebugCommand, DumpCommand, UpdateCommand};
 
 fn parse_bpos(input: &str) -> IResult<&str, bpos> {
     let (input, (inode, _, offset, _, snapshot)) = tuple((
@@ -41,10 +41,58 @@ fn parse_dump_cmd(input: &str) -> IResult<&str, DebugCommand> {
     ))
 }
 
+fn bkey_name(input: &str) -> IResult<&str, &str> {
+    take_while(|c: char| c.is_alphanumeric() || c == '_')(input)
+}
+
+fn field_name(input: &str) -> IResult<&str, &str> {
+    take_while(|c: char| c.is_alphanumeric() || c == '_' || c == '.')(input)
+}
+
+fn bkey_op(input: &str) -> IResult<&str, bkey_update_op> {
+    let (input, op) = alt((tag("="), tag("+=")))(input)?;
+    match op {
+        "=" => Ok((input, bkey_update_op::BKEY_CMD_SET)),
+        "+=" => Ok((input, bkey_update_op::BKEY_CMD_ADD)),
+        _ => unreachable!(),
+    }
+}
+
+fn parse_update_cmd(input: &str) -> IResult<&str, DebugCommand> {
+    let (input, (_, btree, _, bpos, _, bkey, _, field, op, value)) = all_consuming(tuple((
+        space1,
+        alpha1,
+        space1,
+        parse_bpos,
+        space1,
+        bkey_name,
+        char('.'),
+        field_name,
+        bkey_op,
+        u64,
+    )))(input)?;
+
+    Ok((
+        input,
+        DebugCommand::Update(UpdateCommand {
+            btree: btree.to_string(),
+            bpos,
+            bkey: bkey.to_string(),
+            field: field.to_string(),
+            op,
+            value,
+        }),
+    ))
+}
+
 fn parse_command_inner(input: &str) -> IResult<&str, DebugCommand> {
-    let (input, _) = tag("dump")(input)?;
+    let (input, cmd) = alt((tag("dump"), tag("update")))(input)?;
 
-    parse_dump_cmd(input)
+    match cmd {
+        "dump" => parse_dump_cmd(input),
+        "update" => parse_update_cmd(input),
+        _ => unreachable!(),
+    }
 }
 
 /// Given an input string, tries to parse it into a valid
-- 
2.45.2

