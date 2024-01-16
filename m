Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F8B10A05
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 06:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ekDiwMYI"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7bc32b0fdadso333209139f.2
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 22:41:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705387294; x=1705992094; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=nF6TXt+3nEclNCW09792KHyUgeSqo8xKUeR8kj1QZUY=;
        b=ekDiwMYIUBy3x6fyozjdf6lj1xplI8OA5d/TnhSKdihl3nz2xCjcfBNgYZKJdo89xb
         /hkMnKdfDRFUQ9PyaSKl3ZhgRQcWIn+QPPol/8uFi5RYzIc41Dm2TyIkFJGdptVzcNEy
         0Bdrt01QpgSvps+YDUXG4VXFPQrHQ5IO/cbTLgvPAJXgfI1+XG480tU2d4vsowwt7TXT
         L9Za6kyvVFdJu3gty2BqyGTLPJ1gLdhMd9mZMsKBozEFx38B6Rpi/88iZIm4laEnhs5I
         1Vss//fxwHCrOBzVFI3BI/xfeaIty7eJbIOXTnOJaQ+Bvu1YDsUroorFzAli4sZmC3Nn
         QxKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705387294; x=1705992094;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nF6TXt+3nEclNCW09792KHyUgeSqo8xKUeR8kj1QZUY=;
        b=LmAgrbhfayN7cpB3lNxgT1gaSA3b1P2trn+HwEgejinjmyzSMQUc4zoDZ2y5Cnd1NX
         0HzKQRDECDYFEXBvaZOmZ+SRn0mjK9iTbxuuPz5B5WxjQNUk31Ayz6pXJV4/481FaV5W
         K4y8TLOKmGuuYBTPHjfYcEqoBPR/Yx4oGk3Sy4S3pARdYopOaJqOnqh5WnxEYOozbt0A
         PdQ4YbFlTywBShiI86JN9HYODh5V37yiCRSBpVwcwZiDIctjHzmpRbU39WvSs20BjdhP
         P0pU8EVxoSNFfKYkWb+w1pM1smgQ2KJKbRlQxJa9dzh6DnIbnG78WQ5jWNyoEYewDsbO
         im/A==
X-Gm-Message-State: AOJu0Yx98zmrTrlqMreFEz5PNAdJU+a46n/x2yYXH8247KA2V2vOMUrg
	AiSVEfnQiaMxmpxsqql+N23ZmAtLOSzfiA==
X-Google-Smtp-Source: AGHT+IEP6+E8U2pMSWJFyZ4Lqrwcc8O0LYJ/dnHnA4VvdqkOfyLQdb0ac6bIoHl9/gjyVUZaNHyiuQ==
X-Received: by 2002:a5e:dd09:0:b0:7bf:2c0f:2263 with SMTP id t9-20020a5edd09000000b007bf2c0f2263mr4586857iop.0.1705387293838;
        Mon, 15 Jan 2024 22:41:33 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id t24-20020a6bdb18000000b007bf3d8f13c6sm1124309ioc.6.2024.01.15.22.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 22:41:33 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 0/3] convert main() C -> Rust
Date: Mon, 15 Jan 2024 23:40:59 -0700
Message-ID: <20240116064102.193643-1-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

v2 of this series is mostly the same as v1 in the first 2 patches. The
main difference is a fixup for the GitHub CI failure.

The new 3rd patch moves the Rust sources out of rust-src/ and into the
toplevel, and moves the C sources into c_src/. This doesn't involve any
functionality or code changes, but there's a lot of updating to make
things look in the new locations. As before, let me know if anyone sees
anything I missed, but hopefully I got everything...

Thomas Bertschinger (3):
  convert main() from C to Rust
  remove library from bcachefs-tools Rust package
  move Rust sources to top level, C sources into c_src

 .github/workflows/build-packages.yml          |   4 +-
 .gitignore                                    |  10 ++
 rust-src/Cargo.lock => Cargo.lock             |   2 +-
 rust-src/Cargo.toml => Cargo.toml             |   7 +-
 Makefile                                      |  36 ++---
 .../bch_bindgen => bch_bindgen}/.gitignore    |   0
 .../bch_bindgen => bch_bindgen}/Cargo.lock    |   0
 .../bch_bindgen => bch_bindgen}/Cargo.toml    |   0
 .../bch_bindgen => bch_bindgen}/build.rs      |   9 +-
 .../bch_bindgen => bch_bindgen}/rustfmt.toml  |   0
 .../src/bcachefs.rs                           |   0
 .../bch_bindgen => bch_bindgen}/src/bkey.rs   |   0
 .../bch_bindgen => bch_bindgen}/src/btree.rs  |   0
 .../src/errcode.rs                            |   0
 .../bch_bindgen => bch_bindgen}/src/fs.rs     |   0
 .../src/keyutils.rs                           |   0
 .../src/keyutils_wrapper.h                    |   0
 .../bch_bindgen => bch_bindgen}/src/lib.rs    |   0
 bch_bindgen/src/libbcachefs_wrapper.h         |  22 +++
 .../bch_bindgen => bch_bindgen}/src/opts.rs   |   0
 .../bch_bindgen => bch_bindgen}/src/rs.rs     |   0
 build.nix                                     |   4 +-
 build.rs                                      |  21 +++
 bcachefs.c => c_src/bcachefs.c                | 127 +-----------------
 {ccan => c_src/ccan}/array_size/LICENSE       |   0
 {ccan => c_src/ccan}/array_size/_info         |   0
 {ccan => c_src/ccan}/array_size/array_size.h  |   0
 {ccan => c_src/ccan}/build_assert/LICENSE     |   0
 {ccan => c_src/ccan}/build_assert/_info       |   0
 .../ccan}/build_assert/build_assert.h         |   0
 {ccan => c_src/ccan}/compiler/LICENSE         |   0
 {ccan => c_src/ccan}/compiler/_info           |   0
 {ccan => c_src/ccan}/compiler/compiler.h      |   0
 cmd_assemble.c => c_src/cmd_assemble.c        |   0
 cmd_attr.c => c_src/cmd_attr.c                |   0
 cmd_counters.c => c_src/cmd_counters.c        |   0
 cmd_data.c => c_src/cmd_data.c                |   0
 cmd_device.c => c_src/cmd_device.c            |   0
 cmd_dump.c => c_src/cmd_dump.c                |   0
 cmd_format.c => c_src/cmd_format.c            |   0
 cmd_fs.c => c_src/cmd_fs.c                    |   0
 cmd_fsck.c => c_src/cmd_fsck.c                |   0
 cmd_fusemount.c => c_src/cmd_fusemount.c      |   0
 cmd_key.c => c_src/cmd_key.c                  |   0
 .../cmd_kill_btree_node.c                     |   0
 .../cmd_list_journal.c                        |   0
 cmd_migrate.c => c_src/cmd_migrate.c          |   0
 cmd_option.c => c_src/cmd_option.c            |   0
 cmd_run.c => c_src/cmd_run.c                  |   0
 cmd_subvolume.c => c_src/cmd_subvolume.c      |   0
 cmd_version.c => c_src/cmd_version.c          |   0
 cmds.h => c_src/cmds.h                        |   6 +-
 config.h => c_src/config.h                    |   0
 crypto.c => c_src/crypto.c                    |   0
 crypto.h => c_src/crypto.h                    |   0
 {include => c_src/include}/asm/page.h         |   0
 {include => c_src/include}/asm/unaligned.h    |   0
 {include => c_src/include}/crypto/algapi.h    |   0
 {include => c_src/include}/crypto/chacha.h    |   0
 {include => c_src/include}/crypto/hash.h      |   0
 {include => c_src/include}/crypto/poly1305.h  |   0
 {include => c_src/include}/crypto/sha2.h      |   0
 {include => c_src/include}/crypto/skcipher.h  |   0
 {include => c_src/include}/keys/user-type.h   |   0
 {include => c_src/include}/linux/atomic.h     |   0
 .../include}/linux/backing-dev-defs.h         |   0
 .../include}/linux/backing-dev.h              |   0
 {include => c_src/include}/linux/bio.h        |   0
 .../include}/linux/bit_spinlock.h             |   0
 {include => c_src/include}/linux/bitmap.h     |   0
 {include => c_src/include}/linux/bitops.h     |   0
 {include => c_src/include}/linux/blk_types.h  |   0
 {include => c_src/include}/linux/blkdev.h     |   0
 {include => c_src/include}/linux/bsearch.h    |   0
 {include => c_src/include}/linux/bug.h        |   0
 {include => c_src/include}/linux/bvec.h       |   0
 {include => c_src/include}/linux/byteorder.h  |   0
 {include => c_src/include}/linux/cache.h      |   0
 {include => c_src/include}/linux/closure.h    |   0
 {include => c_src/include}/linux/compiler.h   |   0
 {include => c_src/include}/linux/completion.h |   0
 {include => c_src/include}/linux/console.h    |   0
 {include => c_src/include}/linux/cpumask.h    |   0
 {include => c_src/include}/linux/crc32c.h     |   0
 {include => c_src/include}/linux/crc64.h      |   0
 {include => c_src/include}/linux/crypto.h     |   0
 {include => c_src/include}/linux/ctype.h      |   0
 {include => c_src/include}/linux/dcache.h     |   0
 {include => c_src/include}/linux/debugfs.h    |   0
 {include => c_src/include}/linux/device.h     |   0
 .../include}/linux/dynamic_fault.h            |   0
 {include => c_src/include}/linux/err.h        |   0
 {include => c_src/include}/linux/errname.h    |   0
 {include => c_src/include}/linux/export.h     |   0
 {include => c_src/include}/linux/freezer.h    |   0
 .../include}/linux/generic-radix-tree.h       |   0
 {include => c_src/include}/linux/genhd.h      |   0
 {include => c_src/include}/linux/gfp.h        |   0
 {include => c_src/include}/linux/hash.h       |   0
 {include => c_src/include}/linux/idr.h        |   0
 {include => c_src/include}/linux/ioprio.h     |   0
 {include => c_src/include}/linux/jhash.h      |   0
 {include => c_src/include}/linux/jiffies.h    |   0
 {include => c_src/include}/linux/kernel.h     |   0
 {include => c_src/include}/linux/key.h        |   0
 {include => c_src/include}/linux/kmemleak.h   |   0
 {include => c_src/include}/linux/kobject.h    |   0
 {include => c_src/include}/linux/kthread.h    |   0
 {include => c_src/include}/linux/list.h       |   0
 {include => c_src/include}/linux/list_nulls.h |   0
 {include => c_src/include}/linux/llist.h      |   0
 {include => c_src/include}/linux/lockdep.h    |   0
 {include => c_src/include}/linux/log2.h       |   0
 {include => c_src/include}/linux/lz4.h        |   0
 {include => c_src/include}/linux/math.h       |   0
 {include => c_src/include}/linux/math64.h     |   0
 {include => c_src/include}/linux/mempool.h    |   0
 {include => c_src/include}/linux/minmax.h     |   0
 {include => c_src/include}/linux/mm.h         |   0
 {include => c_src/include}/linux/module.h     |   0
 {include => c_src/include}/linux/mutex.h      |   0
 {include => c_src/include}/linux/osq_lock.h   |   0
 {include => c_src/include}/linux/overflow.h   |   0
 {include => c_src/include}/linux/page.h       |   0
 .../include}/linux/percpu-refcount.h          |   0
 .../include}/linux/percpu-rwsem.h             |   0
 {include => c_src/include}/linux/percpu.h     |   0
 {include => c_src/include}/linux/poison.h     |   0
 {include => c_src/include}/linux/posix_acl.h  |   0
 .../include}/linux/posix_acl_xattr.h          |   0
 {include => c_src/include}/linux/prandom.h    |   0
 {include => c_src/include}/linux/preempt.h    |   0
 {include => c_src/include}/linux/prefetch.h   |   0
 .../include}/linux/pretty-printers.h          |   0
 {include => c_src/include}/linux/printk.h     |   0
 {include => c_src/include}/linux/random.h     |   0
 {include => c_src/include}/linux/ratelimit.h  |   0
 {include => c_src/include}/linux/rculist.h    |   0
 {include => c_src/include}/linux/rcupdate.h   |   0
 {include => c_src/include}/linux/refcount.h   |   0
 .../include}/linux/rhashtable-types.h         |   0
 {include => c_src/include}/linux/rhashtable.h |   0
 {include => c_src/include}/linux/rwsem.h      |   0
 .../include}/linux/scatterlist.h              |   0
 {include => c_src/include}/linux/sched.h      |   0
 .../include}/linux/sched/clock.h              |   0
 .../include}/linux/sched/cputime.h            |   0
 .../include}/linux/sched/debug.h              |   0
 {include => c_src/include}/linux/sched/mm.h   |   0
 {include => c_src/include}/linux/sched/rt.h   |   0
 .../include}/linux/sched/signal.h             |   0
 {include => c_src/include}/linux/sched/task.h |   0
 .../include}/linux/sched/task_stack.h         |   0
 {include => c_src/include}/linux/semaphore.h  |   0
 {include => c_src/include}/linux/seq_buf.h    |   0
 {include => c_src/include}/linux/seq_file.h   |   0
 {include => c_src/include}/linux/seqlock.h    |   0
 {include => c_src/include}/linux/shrinker.h   |   0
 {include => c_src/include}/linux/siphash.h    |   0
 {include => c_src/include}/linux/slab.h       |   0
 {include => c_src/include}/linux/sort.h       |   0
 {include => c_src/include}/linux/spinlock.h   |   0
 {include => c_src/include}/linux/srcu.h       |   0
 {include => c_src/include}/linux/stat.h       |   0
 {include => c_src/include}/linux/string.h     |   0
 .../include}/linux/string_helpers.h           |   0
 {include => c_src/include}/linux/sysfs.h      |   0
 {include => c_src/include}/linux/time64.h     |   0
 {include => c_src/include}/linux/timer.h      |   0
 {include => c_src/include}/linux/tracepoint.h |   0
 {include => c_src/include}/linux/typecheck.h  |   0
 {include => c_src/include}/linux/types.h      |   0
 .../include}/linux/unaligned/be_byteshift.h   |   0
 .../include}/linux/unaligned/be_struct.h      |   0
 .../include}/linux/unaligned/generic.h        |   0
 .../include}/linux/unaligned/le_byteshift.h   |   0
 .../include}/linux/unaligned/le_struct.h      |   0
 .../include}/linux/unaligned/packed_struct.h  |   0
 {include => c_src/include}/linux/uuid.h       |   0
 {include => c_src/include}/linux/vmalloc.h    |   0
 {include => c_src/include}/linux/wait.h       |   0
 {include => c_src/include}/linux/workqueue.h  |   0
 {include => c_src/include}/linux/xattr.h      |   0
 {include => c_src/include}/linux/xxhash.h     |   0
 {include => c_src/include}/linux/zlib.h       |   0
 {include => c_src/include}/linux/zstd.h       |   0
 .../include}/linux/zstd_errors.h              |   0
 .../include}/trace/define_trace.h             |   0
 .../include}/trace/events/lock.h              |   0
 {include => c_src/include}/uapi/linux/xattr.h |   0
 libbcachefs.c => c_src/libbcachefs.c          |   0
 libbcachefs.h => c_src/libbcachefs.h          |   0
 {libbcachefs => c_src/libbcachefs}/acl.c      |   0
 {libbcachefs => c_src/libbcachefs}/acl.h      |   0
 .../libbcachefs}/alloc_background.c           |   0
 .../libbcachefs}/alloc_background.h           |   0
 .../libbcachefs}/alloc_foreground.c           |   0
 .../libbcachefs}/alloc_foreground.h           |   0
 .../libbcachefs}/alloc_types.h                |   0
 .../libbcachefs}/backpointers.c               |   0
 .../libbcachefs}/backpointers.h               |   0
 {libbcachefs => c_src/libbcachefs}/bbpos.h    |   0
 .../libbcachefs}/bbpos_types.h                |   0
 {libbcachefs => c_src/libbcachefs}/bcachefs.h |   0
 .../libbcachefs}/bcachefs_format.h            |   0
 .../libbcachefs}/bcachefs_ioctl.h             |   0
 {libbcachefs => c_src/libbcachefs}/bkey.c     |   0
 {libbcachefs => c_src/libbcachefs}/bkey.h     |   0
 {libbcachefs => c_src/libbcachefs}/bkey_buf.h |   0
 {libbcachefs => c_src/libbcachefs}/bkey_cmp.h |   0
 .../libbcachefs}/bkey_methods.c               |   0
 .../libbcachefs}/bkey_methods.h               |   0
 .../libbcachefs}/bkey_sort.c                  |   0
 .../libbcachefs}/bkey_sort.h                  |   0
 {libbcachefs => c_src/libbcachefs}/bset.c     |   0
 {libbcachefs => c_src/libbcachefs}/bset.h     |   0
 .../libbcachefs}/btree_cache.c                |   0
 .../libbcachefs}/btree_cache.h                |   0
 {libbcachefs => c_src/libbcachefs}/btree_gc.c |   0
 {libbcachefs => c_src/libbcachefs}/btree_gc.h |   0
 {libbcachefs => c_src/libbcachefs}/btree_io.c |   0
 {libbcachefs => c_src/libbcachefs}/btree_io.h |   0
 .../libbcachefs}/btree_iter.c                 |   0
 .../libbcachefs}/btree_iter.h                 |   0
 .../libbcachefs}/btree_journal_iter.c         |   0
 .../libbcachefs}/btree_journal_iter.h         |   0
 .../libbcachefs}/btree_key_cache.c            |   0
 .../libbcachefs}/btree_key_cache.h            |   0
 .../libbcachefs}/btree_key_cache_types.h      |   0
 .../libbcachefs}/btree_locking.c              |   0
 .../libbcachefs}/btree_locking.h              |   0
 .../libbcachefs}/btree_trans_commit.c         |   0
 .../libbcachefs}/btree_types.h                |   0
 .../libbcachefs}/btree_update.c               |   0
 .../libbcachefs}/btree_update.h               |   0
 .../libbcachefs}/btree_update_interior.c      |   0
 .../libbcachefs}/btree_update_interior.h      |   0
 .../libbcachefs}/btree_write_buffer.c         |   0
 .../libbcachefs}/btree_write_buffer.h         |   0
 .../libbcachefs}/btree_write_buffer_types.h   |   0
 {libbcachefs => c_src/libbcachefs}/buckets.c  |   0
 {libbcachefs => c_src/libbcachefs}/buckets.h  |   0
 .../libbcachefs}/buckets_types.h              |   0
 .../buckets_waiting_for_journal.c             |   0
 .../buckets_waiting_for_journal.h             |   0
 .../buckets_waiting_for_journal_types.h       |   0
 {libbcachefs => c_src/libbcachefs}/chardev.c  |   0
 {libbcachefs => c_src/libbcachefs}/chardev.h  |   0
 {libbcachefs => c_src/libbcachefs}/checksum.c |   0
 {libbcachefs => c_src/libbcachefs}/checksum.h |   0
 {libbcachefs => c_src/libbcachefs}/clock.c    |   0
 {libbcachefs => c_src/libbcachefs}/clock.h    |   0
 .../libbcachefs}/clock_types.h                |   0
 {libbcachefs => c_src/libbcachefs}/compress.c |   0
 {libbcachefs => c_src/libbcachefs}/compress.h |   0
 {libbcachefs => c_src/libbcachefs}/counters.c |   0
 {libbcachefs => c_src/libbcachefs}/counters.h |   0
 {libbcachefs => c_src/libbcachefs}/darray.c   |   0
 {libbcachefs => c_src/libbcachefs}/darray.h   |   0
 .../libbcachefs}/data_update.c                |   0
 .../libbcachefs}/data_update.h                |   0
 {libbcachefs => c_src/libbcachefs}/debug.c    |   0
 {libbcachefs => c_src/libbcachefs}/debug.h    |   0
 {libbcachefs => c_src/libbcachefs}/dirent.c   |   0
 {libbcachefs => c_src/libbcachefs}/dirent.h   |   0
 .../libbcachefs}/disk_groups.c                |   0
 .../libbcachefs}/disk_groups.h                |   0
 .../libbcachefs}/disk_groups_types.h          |   0
 {libbcachefs => c_src/libbcachefs}/ec.c       |   0
 {libbcachefs => c_src/libbcachefs}/ec.h       |   0
 {libbcachefs => c_src/libbcachefs}/ec_types.h |   0
 {libbcachefs => c_src/libbcachefs}/errcode.c  |   0
 {libbcachefs => c_src/libbcachefs}/errcode.h  |   0
 {libbcachefs => c_src/libbcachefs}/error.c    |   0
 {libbcachefs => c_src/libbcachefs}/error.h    |   0
 .../libbcachefs}/extent_update.c              |   0
 .../libbcachefs}/extent_update.h              |   0
 {libbcachefs => c_src/libbcachefs}/extents.c  |   0
 {libbcachefs => c_src/libbcachefs}/extents.h  |   0
 .../libbcachefs}/extents_types.h              |   0
 .../libbcachefs}/eytzinger.h                  |   0
 {libbcachefs => c_src/libbcachefs}/fifo.h     |   0
 .../libbcachefs}/fs-common.c                  |   0
 .../libbcachefs}/fs-common.h                  |   0
 .../libbcachefs}/fs-io-buffered.c             |   0
 .../libbcachefs}/fs-io-buffered.h             |   0
 .../libbcachefs}/fs-io-direct.c               |   0
 .../libbcachefs}/fs-io-direct.h               |   0
 .../libbcachefs}/fs-io-pagecache.c            |   0
 .../libbcachefs}/fs-io-pagecache.h            |   0
 {libbcachefs => c_src/libbcachefs}/fs-io.c    |   0
 {libbcachefs => c_src/libbcachefs}/fs-io.h    |   0
 {libbcachefs => c_src/libbcachefs}/fs-ioctl.c |   0
 {libbcachefs => c_src/libbcachefs}/fs-ioctl.h |   0
 {libbcachefs => c_src/libbcachefs}/fs.c       |   0
 {libbcachefs => c_src/libbcachefs}/fs.h       |   0
 {libbcachefs => c_src/libbcachefs}/fsck.c     |   0
 {libbcachefs => c_src/libbcachefs}/fsck.h     |   0
 {libbcachefs => c_src/libbcachefs}/inode.c    |   0
 {libbcachefs => c_src/libbcachefs}/inode.h    |   0
 {libbcachefs => c_src/libbcachefs}/io_misc.c  |   0
 {libbcachefs => c_src/libbcachefs}/io_misc.h  |   0
 {libbcachefs => c_src/libbcachefs}/io_read.c  |   0
 {libbcachefs => c_src/libbcachefs}/io_read.h  |   0
 {libbcachefs => c_src/libbcachefs}/io_write.c |   0
 {libbcachefs => c_src/libbcachefs}/io_write.h |   0
 .../libbcachefs}/io_write_types.h             |   0
 {libbcachefs => c_src/libbcachefs}/journal.c  |   0
 {libbcachefs => c_src/libbcachefs}/journal.h  |   0
 .../libbcachefs}/journal_io.c                 |   0
 .../libbcachefs}/journal_io.h                 |   0
 .../libbcachefs}/journal_reclaim.c            |   0
 .../libbcachefs}/journal_reclaim.h            |   0
 .../libbcachefs}/journal_sb.c                 |   0
 .../libbcachefs}/journal_sb.h                 |   0
 .../libbcachefs}/journal_seq_blacklist.c      |   0
 .../libbcachefs}/journal_seq_blacklist.h      |   0
 .../libbcachefs}/journal_types.h              |   0
 {libbcachefs => c_src/libbcachefs}/keylist.c  |   0
 {libbcachefs => c_src/libbcachefs}/keylist.h  |   0
 .../libbcachefs}/keylist_types.h              |   0
 .../libbcachefs}/logged_ops.c                 |   0
 .../libbcachefs}/logged_ops.h                 |   0
 {libbcachefs => c_src/libbcachefs}/lru.c      |   0
 {libbcachefs => c_src/libbcachefs}/lru.h      |   0
 .../libbcachefs}/mean_and_variance.c          |   0
 .../libbcachefs}/mean_and_variance.h          |   0
 {libbcachefs => c_src/libbcachefs}/migrate.c  |   0
 {libbcachefs => c_src/libbcachefs}/migrate.h  |   0
 {libbcachefs => c_src/libbcachefs}/move.c     |   0
 {libbcachefs => c_src/libbcachefs}/move.h     |   0
 .../libbcachefs}/move_types.h                 |   0
 {libbcachefs => c_src/libbcachefs}/movinggc.c |   0
 {libbcachefs => c_src/libbcachefs}/movinggc.h |   0
 .../libbcachefs}/nocow_locking.c              |   0
 .../libbcachefs}/nocow_locking.h              |   0
 .../libbcachefs}/nocow_locking_types.h        |   0
 {libbcachefs => c_src/libbcachefs}/opts.c     |   0
 {libbcachefs => c_src/libbcachefs}/opts.h     |   0
 {libbcachefs => c_src/libbcachefs}/printbuf.c |   0
 {libbcachefs => c_src/libbcachefs}/printbuf.h |   0
 {libbcachefs => c_src/libbcachefs}/quota.c    |   0
 {libbcachefs => c_src/libbcachefs}/quota.h    |   0
 .../libbcachefs}/quota_types.h                |   0
 .../libbcachefs}/rebalance.c                  |   0
 .../libbcachefs}/rebalance.h                  |   0
 .../libbcachefs}/rebalance_types.h            |   0
 {libbcachefs => c_src/libbcachefs}/recovery.c |   0
 {libbcachefs => c_src/libbcachefs}/recovery.h |   0
 .../libbcachefs}/recovery_types.h             |   0
 {libbcachefs => c_src/libbcachefs}/reflink.c  |   0
 {libbcachefs => c_src/libbcachefs}/reflink.h  |   0
 {libbcachefs => c_src/libbcachefs}/replicas.c |   0
 {libbcachefs => c_src/libbcachefs}/replicas.h |   0
 .../libbcachefs}/replicas_types.h             |   0
 {libbcachefs => c_src/libbcachefs}/sb-clean.c |   0
 {libbcachefs => c_src/libbcachefs}/sb-clean.h |   0
 .../libbcachefs}/sb-downgrade.c               |   0
 .../libbcachefs}/sb-downgrade.h               |   0
 .../libbcachefs}/sb-errors.c                  |   0
 .../libbcachefs}/sb-errors.h                  |   0
 .../libbcachefs}/sb-errors_types.h            |   0
 .../libbcachefs}/sb-members.c                 |   0
 .../libbcachefs}/sb-members.h                 |   0
 {libbcachefs => c_src/libbcachefs}/seqmutex.h |   0
 {libbcachefs => c_src/libbcachefs}/siphash.c  |   0
 {libbcachefs => c_src/libbcachefs}/siphash.h  |   0
 {libbcachefs => c_src/libbcachefs}/six.c      |   0
 {libbcachefs => c_src/libbcachefs}/six.h      |   0
 {libbcachefs => c_src/libbcachefs}/snapshot.c |   0
 {libbcachefs => c_src/libbcachefs}/snapshot.h |   0
 {libbcachefs => c_src/libbcachefs}/str_hash.h |   0
 .../libbcachefs}/subvolume.c                  |   0
 .../libbcachefs}/subvolume.h                  |   0
 .../libbcachefs}/subvolume_types.h            |   0
 {libbcachefs => c_src/libbcachefs}/super-io.c |   0
 {libbcachefs => c_src/libbcachefs}/super-io.h |   0
 {libbcachefs => c_src/libbcachefs}/super.c    |   0
 {libbcachefs => c_src/libbcachefs}/super.h    |   0
 .../libbcachefs}/super_types.h                |   0
 {libbcachefs => c_src/libbcachefs}/sysfs.c    |   0
 {libbcachefs => c_src/libbcachefs}/sysfs.h    |   0
 {libbcachefs => c_src/libbcachefs}/tests.c    |   0
 {libbcachefs => c_src/libbcachefs}/tests.h    |   0
 .../libbcachefs}/thread_with_file.c           |   0
 .../libbcachefs}/thread_with_file.h           |   0
 .../libbcachefs}/thread_with_file_types.h     |   0
 {libbcachefs => c_src/libbcachefs}/trace.c    |   0
 {libbcachefs => c_src/libbcachefs}/trace.h    |   0
 .../libbcachefs}/two_state_shared_lock.c      |   0
 .../libbcachefs}/two_state_shared_lock.h      |   0
 {libbcachefs => c_src/libbcachefs}/util.c     |   0
 {libbcachefs => c_src/libbcachefs}/util.h     |   0
 {libbcachefs => c_src/libbcachefs}/varint.c   |   0
 {libbcachefs => c_src/libbcachefs}/varint.h   |   0
 {libbcachefs => c_src/libbcachefs}/vstructs.h |   0
 {libbcachefs => c_src/libbcachefs}/xattr.c    |   0
 {libbcachefs => c_src/libbcachefs}/xattr.h    |   0
 {linux => c_src/linux}/atomic64.c             |   0
 {linux => c_src/linux}/bio.c                  |   0
 {linux => c_src/linux}/blkdev.c               |   0
 {linux => c_src/linux}/closure.c              |   0
 {linux => c_src/linux}/crc64.c                |   0
 {linux => c_src/linux}/crc64table.h           |   0
 {linux => c_src/linux}/crypto/api.c           |   0
 .../linux}/crypto/chacha20_generic.c          |   0
 .../linux}/crypto/poly1305_generic.c          |   0
 .../linux}/crypto/sha256_generic.c            |   0
 {linux => c_src/linux}/fs.c                   |   0
 {linux => c_src/linux}/generic-radix-tree.c   |   0
 {linux => c_src/linux}/int_sqrt.c             |   0
 {linux => c_src/linux}/kstrtox.c              |   0
 {linux => c_src/linux}/kstrtox.h              |   0
 {linux => c_src/linux}/kthread.c              |   0
 {linux => c_src/linux}/llist.c                |   0
 {linux => c_src/linux}/mempool.c              |   0
 {linux => c_src/linux}/preempt.c              |   0
 {linux => c_src/linux}/ratelimit.c            |   0
 {linux => c_src/linux}/rhashtable.c           |   0
 {linux => c_src/linux}/sched.c                |   0
 {linux => c_src/linux}/semaphore.c            |   0
 {linux => c_src/linux}/seq_buf.c              |   0
 {linux => c_src/linux}/shrinker.c             |   0
 {linux => c_src/linux}/siphash.c              |   0
 {linux => c_src/linux}/string.c               |   0
 {linux => c_src/linux}/string_helpers.c       |   0
 {linux => c_src/linux}/timer.c                |   0
 {linux => c_src/linux}/wait.c                 |   0
 {linux => c_src/linux}/workqueue.c            |   0
 {linux => c_src/linux}/xxhash.c               |   0
 {linux => c_src/linux}/zstd_compress_module.c |   0
 .../linux}/zstd_decompress_module.c           |   0
 qcow2.c => c_src/qcow2.c                      |   0
 qcow2.h => c_src/qcow2.h                      |   0
 {raid => c_src/raid}/COPYING                  |   0
 {raid => c_src/raid}/check.c                  |   0
 {raid => c_src/raid}/combo.h                  |   0
 {raid => c_src/raid}/cpu.h                    |   0
 {raid => c_src/raid}/gf.h                     |   0
 {raid => c_src/raid}/helper.c                 |   0
 {raid => c_src/raid}/helper.h                 |   0
 {raid => c_src/raid}/int.c                    |   0
 {raid => c_src/raid}/internal.h               |   0
 {raid => c_src/raid}/intz.c                   |   0
 {raid => c_src/raid}/memory.c                 |   0
 {raid => c_src/raid}/memory.h                 |   0
 {raid => c_src/raid}/module.c                 |   0
 {raid => c_src/raid}/raid.c                   |   0
 {raid => c_src/raid}/raid.h                   |   0
 {raid => c_src/raid}/tables.c                 |   0
 {raid => c_src/raid}/tag.c                    |   0
 {raid => c_src/raid}/test.c                   |   0
 {raid => c_src/raid}/test.h                   |   0
 {raid => c_src/raid}/x86.c                    |   0
 {raid => c_src/raid}/x86z.c                   |   0
 tools-util.c => c_src/tools-util.c            |   0
 tools-util.h => c_src/tools-util.h            |   0
 make-release-tarball.sh                       |   4 +-
 rust-src/.gitignore                           |  15 ---
 rust-src/README.md                            |  62 ---------
 .../bch_bindgen/src/libbcachefs_wrapper.h     |  20 ---
 rust-src/src/cmd_main.rs                      |  34 -----
 rust-src/src/lib.rs                           |  54 --------
 rust-src/rustfmt.toml => rustfmt.toml         |   0
 src/bcachefs.rs                               | 120 +++++++++++++++++
 .../src => src/commands}/cmd_completions.rs   |   3 +-
 {rust-src/src => src/commands}/cmd_list.rs    |   3 +-
 {rust-src/src => src/commands}/cmd_mount.rs   |  11 +-
 {rust-src/src => src/commands}/logger.rs      |   0
 src/commands/mod.rs                           |  31 +++++
 {rust-src/src => src}/key.rs                  |   0
 tests/util.py                                 |   2 +-
 472 files changed, 258 insertions(+), 349 deletions(-)
 rename rust-src/Cargo.lock => Cargo.lock (99%)
 rename rust-src/Cargo.toml => Cargo.toml (88%)
 rename {rust-src/bch_bindgen => bch_bindgen}/.gitignore (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/Cargo.lock (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/Cargo.toml (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/build.rs (92%)
 rename {rust-src/bch_bindgen => bch_bindgen}/rustfmt.toml (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/bcachefs.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/bkey.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/btree.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/errcode.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/fs.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/keyutils.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/keyutils_wrapper.h (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/lib.rs (100%)
 create mode 100644 bch_bindgen/src/libbcachefs_wrapper.h
 rename {rust-src/bch_bindgen => bch_bindgen}/src/opts.rs (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/src/rs.rs (100%)
 create mode 100644 build.rs
 rename bcachefs.c => c_src/bcachefs.c (65%)
 rename {ccan => c_src/ccan}/array_size/LICENSE (100%)
 rename {ccan => c_src/ccan}/array_size/_info (100%)
 rename {ccan => c_src/ccan}/array_size/array_size.h (100%)
 rename {ccan => c_src/ccan}/build_assert/LICENSE (100%)
 rename {ccan => c_src/ccan}/build_assert/_info (100%)
 rename {ccan => c_src/ccan}/build_assert/build_assert.h (100%)
 rename {ccan => c_src/ccan}/compiler/LICENSE (100%)
 rename {ccan => c_src/ccan}/compiler/_info (100%)
 rename {ccan => c_src/ccan}/compiler/compiler.h (100%)
 rename cmd_assemble.c => c_src/cmd_assemble.c (100%)
 rename cmd_attr.c => c_src/cmd_attr.c (100%)
 rename cmd_counters.c => c_src/cmd_counters.c (100%)
 rename cmd_data.c => c_src/cmd_data.c (100%)
 rename cmd_device.c => c_src/cmd_device.c (100%)
 rename cmd_dump.c => c_src/cmd_dump.c (100%)
 rename cmd_format.c => c_src/cmd_format.c (100%)
 rename cmd_fs.c => c_src/cmd_fs.c (100%)
 rename cmd_fsck.c => c_src/cmd_fsck.c (100%)
 rename cmd_fusemount.c => c_src/cmd_fusemount.c (100%)
 rename cmd_key.c => c_src/cmd_key.c (100%)
 rename cmd_kill_btree_node.c => c_src/cmd_kill_btree_node.c (100%)
 rename cmd_list_journal.c => c_src/cmd_list_journal.c (100%)
 rename cmd_migrate.c => c_src/cmd_migrate.c (100%)
 rename cmd_option.c => c_src/cmd_option.c (100%)
 rename cmd_run.c => c_src/cmd_run.c (100%)
 rename cmd_subvolume.c => c_src/cmd_subvolume.c (100%)
 rename cmd_version.c => c_src/cmd_version.c (100%)
 rename cmds.h => c_src/cmds.h (89%)
 rename config.h => c_src/config.h (100%)
 rename crypto.c => c_src/crypto.c (100%)
 rename crypto.h => c_src/crypto.h (100%)
 rename {include => c_src/include}/asm/page.h (100%)
 rename {include => c_src/include}/asm/unaligned.h (100%)
 rename {include => c_src/include}/crypto/algapi.h (100%)
 rename {include => c_src/include}/crypto/chacha.h (100%)
 rename {include => c_src/include}/crypto/hash.h (100%)
 rename {include => c_src/include}/crypto/poly1305.h (100%)
 rename {include => c_src/include}/crypto/sha2.h (100%)
 rename {include => c_src/include}/crypto/skcipher.h (100%)
 rename {include => c_src/include}/keys/user-type.h (100%)
 rename {include => c_src/include}/linux/atomic.h (100%)
 rename {include => c_src/include}/linux/backing-dev-defs.h (100%)
 rename {include => c_src/include}/linux/backing-dev.h (100%)
 rename {include => c_src/include}/linux/bio.h (100%)
 rename {include => c_src/include}/linux/bit_spinlock.h (100%)
 rename {include => c_src/include}/linux/bitmap.h (100%)
 rename {include => c_src/include}/linux/bitops.h (100%)
 rename {include => c_src/include}/linux/blk_types.h (100%)
 rename {include => c_src/include}/linux/blkdev.h (100%)
 rename {include => c_src/include}/linux/bsearch.h (100%)
 rename {include => c_src/include}/linux/bug.h (100%)
 rename {include => c_src/include}/linux/bvec.h (100%)
 rename {include => c_src/include}/linux/byteorder.h (100%)
 rename {include => c_src/include}/linux/cache.h (100%)
 rename {include => c_src/include}/linux/closure.h (100%)
 rename {include => c_src/include}/linux/compiler.h (100%)
 rename {include => c_src/include}/linux/completion.h (100%)
 rename {include => c_src/include}/linux/console.h (100%)
 rename {include => c_src/include}/linux/cpumask.h (100%)
 rename {include => c_src/include}/linux/crc32c.h (100%)
 rename {include => c_src/include}/linux/crc64.h (100%)
 rename {include => c_src/include}/linux/crypto.h (100%)
 rename {include => c_src/include}/linux/ctype.h (100%)
 rename {include => c_src/include}/linux/dcache.h (100%)
 rename {include => c_src/include}/linux/debugfs.h (100%)
 rename {include => c_src/include}/linux/device.h (100%)
 rename {include => c_src/include}/linux/dynamic_fault.h (100%)
 rename {include => c_src/include}/linux/err.h (100%)
 rename {include => c_src/include}/linux/errname.h (100%)
 rename {include => c_src/include}/linux/export.h (100%)
 rename {include => c_src/include}/linux/freezer.h (100%)
 rename {include => c_src/include}/linux/generic-radix-tree.h (100%)
 rename {include => c_src/include}/linux/genhd.h (100%)
 rename {include => c_src/include}/linux/gfp.h (100%)
 rename {include => c_src/include}/linux/hash.h (100%)
 rename {include => c_src/include}/linux/idr.h (100%)
 rename {include => c_src/include}/linux/ioprio.h (100%)
 rename {include => c_src/include}/linux/jhash.h (100%)
 rename {include => c_src/include}/linux/jiffies.h (100%)
 rename {include => c_src/include}/linux/kernel.h (100%)
 rename {include => c_src/include}/linux/key.h (100%)
 rename {include => c_src/include}/linux/kmemleak.h (100%)
 rename {include => c_src/include}/linux/kobject.h (100%)
 rename {include => c_src/include}/linux/kthread.h (100%)
 rename {include => c_src/include}/linux/list.h (100%)
 rename {include => c_src/include}/linux/list_nulls.h (100%)
 rename {include => c_src/include}/linux/llist.h (100%)
 rename {include => c_src/include}/linux/lockdep.h (100%)
 rename {include => c_src/include}/linux/log2.h (100%)
 rename {include => c_src/include}/linux/lz4.h (100%)
 rename {include => c_src/include}/linux/math.h (100%)
 rename {include => c_src/include}/linux/math64.h (100%)
 rename {include => c_src/include}/linux/mempool.h (100%)
 rename {include => c_src/include}/linux/minmax.h (100%)
 rename {include => c_src/include}/linux/mm.h (100%)
 rename {include => c_src/include}/linux/module.h (100%)
 rename {include => c_src/include}/linux/mutex.h (100%)
 rename {include => c_src/include}/linux/osq_lock.h (100%)
 rename {include => c_src/include}/linux/overflow.h (100%)
 rename {include => c_src/include}/linux/page.h (100%)
 rename {include => c_src/include}/linux/percpu-refcount.h (100%)
 rename {include => c_src/include}/linux/percpu-rwsem.h (100%)
 rename {include => c_src/include}/linux/percpu.h (100%)
 rename {include => c_src/include}/linux/poison.h (100%)
 rename {include => c_src/include}/linux/posix_acl.h (100%)
 rename {include => c_src/include}/linux/posix_acl_xattr.h (100%)
 rename {include => c_src/include}/linux/prandom.h (100%)
 rename {include => c_src/include}/linux/preempt.h (100%)
 rename {include => c_src/include}/linux/prefetch.h (100%)
 rename {include => c_src/include}/linux/pretty-printers.h (100%)
 rename {include => c_src/include}/linux/printk.h (100%)
 rename {include => c_src/include}/linux/random.h (100%)
 rename {include => c_src/include}/linux/ratelimit.h (100%)
 rename {include => c_src/include}/linux/rculist.h (100%)
 rename {include => c_src/include}/linux/rcupdate.h (100%)
 rename {include => c_src/include}/linux/refcount.h (100%)
 rename {include => c_src/include}/linux/rhashtable-types.h (100%)
 rename {include => c_src/include}/linux/rhashtable.h (100%)
 rename {include => c_src/include}/linux/rwsem.h (100%)
 rename {include => c_src/include}/linux/scatterlist.h (100%)
 rename {include => c_src/include}/linux/sched.h (100%)
 rename {include => c_src/include}/linux/sched/clock.h (100%)
 rename {include => c_src/include}/linux/sched/cputime.h (100%)
 rename {include => c_src/include}/linux/sched/debug.h (100%)
 rename {include => c_src/include}/linux/sched/mm.h (100%)
 rename {include => c_src/include}/linux/sched/rt.h (100%)
 rename {include => c_src/include}/linux/sched/signal.h (100%)
 rename {include => c_src/include}/linux/sched/task.h (100%)
 rename {include => c_src/include}/linux/sched/task_stack.h (100%)
 rename {include => c_src/include}/linux/semaphore.h (100%)
 rename {include => c_src/include}/linux/seq_buf.h (100%)
 rename {include => c_src/include}/linux/seq_file.h (100%)
 rename {include => c_src/include}/linux/seqlock.h (100%)
 rename {include => c_src/include}/linux/shrinker.h (100%)
 rename {include => c_src/include}/linux/siphash.h (100%)
 rename {include => c_src/include}/linux/slab.h (100%)
 rename {include => c_src/include}/linux/sort.h (100%)
 rename {include => c_src/include}/linux/spinlock.h (100%)
 rename {include => c_src/include}/linux/srcu.h (100%)
 rename {include => c_src/include}/linux/stat.h (100%)
 rename {include => c_src/include}/linux/string.h (100%)
 rename {include => c_src/include}/linux/string_helpers.h (100%)
 rename {include => c_src/include}/linux/sysfs.h (100%)
 rename {include => c_src/include}/linux/time64.h (100%)
 rename {include => c_src/include}/linux/timer.h (100%)
 rename {include => c_src/include}/linux/tracepoint.h (100%)
 rename {include => c_src/include}/linux/typecheck.h (100%)
 rename {include => c_src/include}/linux/types.h (100%)
 rename {include => c_src/include}/linux/unaligned/be_byteshift.h (100%)
 rename {include => c_src/include}/linux/unaligned/be_struct.h (100%)
 rename {include => c_src/include}/linux/unaligned/generic.h (100%)
 rename {include => c_src/include}/linux/unaligned/le_byteshift.h (100%)
 rename {include => c_src/include}/linux/unaligned/le_struct.h (100%)
 rename {include => c_src/include}/linux/unaligned/packed_struct.h (100%)
 rename {include => c_src/include}/linux/uuid.h (100%)
 rename {include => c_src/include}/linux/vmalloc.h (100%)
 rename {include => c_src/include}/linux/wait.h (100%)
 rename {include => c_src/include}/linux/workqueue.h (100%)
 rename {include => c_src/include}/linux/xattr.h (100%)
 rename {include => c_src/include}/linux/xxhash.h (100%)
 rename {include => c_src/include}/linux/zlib.h (100%)
 rename {include => c_src/include}/linux/zstd.h (100%)
 rename {include => c_src/include}/linux/zstd_errors.h (100%)
 rename {include => c_src/include}/trace/define_trace.h (100%)
 rename {include => c_src/include}/trace/events/lock.h (100%)
 rename {include => c_src/include}/uapi/linux/xattr.h (100%)
 rename libbcachefs.c => c_src/libbcachefs.c (100%)
 rename libbcachefs.h => c_src/libbcachefs.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/acl.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/acl.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/alloc_background.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/alloc_background.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/alloc_foreground.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/alloc_foreground.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/alloc_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/backpointers.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/backpointers.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bbpos.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bbpos_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bcachefs.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bcachefs_format.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bcachefs_ioctl.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey_buf.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey_cmp.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey_methods.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey_methods.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey_sort.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/bkey_sort.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/bset.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/bset.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_cache.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_cache.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_gc.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_gc.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_io.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_io.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_iter.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_iter.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_journal_iter.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_journal_iter.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_key_cache.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_key_cache.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_key_cache_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_locking.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_locking.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_trans_commit.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_update.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_update.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_update_interior.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_update_interior.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_write_buffer.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_write_buffer.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/btree_write_buffer_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/buckets.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/buckets.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/buckets_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/buckets_waiting_for_journal.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/buckets_waiting_for_journal.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/buckets_waiting_for_journal_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/chardev.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/chardev.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/checksum.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/checksum.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/clock.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/clock.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/clock_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/compress.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/compress.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/counters.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/counters.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/darray.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/darray.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/data_update.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/data_update.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/debug.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/debug.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/dirent.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/dirent.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/disk_groups.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/disk_groups.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/disk_groups_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/ec.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/ec.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/ec_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/errcode.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/errcode.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/error.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/error.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/extent_update.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/extent_update.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/extents.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/extents.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/extents_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/eytzinger.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fifo.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-common.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-common.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io-buffered.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io-buffered.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io-direct.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io-direct.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io-pagecache.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io-pagecache.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-io.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-ioctl.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs-ioctl.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fs.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/fsck.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/fsck.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/inode.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/inode.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_misc.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_misc.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_read.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_read.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_write.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_write.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/io_write_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_io.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_io.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_reclaim.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_reclaim.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_sb.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_sb.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_seq_blacklist.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_seq_blacklist.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/journal_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/keylist.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/keylist.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/keylist_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/logged_ops.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/logged_ops.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/lru.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/lru.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/mean_and_variance.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/mean_and_variance.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/migrate.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/migrate.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/move.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/move.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/move_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/movinggc.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/movinggc.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/nocow_locking.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/nocow_locking.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/nocow_locking_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/opts.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/opts.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/printbuf.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/printbuf.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/quota.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/quota.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/quota_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/rebalance.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/rebalance.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/rebalance_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/recovery.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/recovery.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/recovery_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/reflink.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/reflink.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/replicas.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/replicas.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/replicas_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-clean.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-clean.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-downgrade.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-downgrade.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-errors.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-errors.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-errors_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-members.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/sb-members.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/seqmutex.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/siphash.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/siphash.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/six.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/six.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/snapshot.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/snapshot.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/str_hash.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/subvolume.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/subvolume.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/subvolume_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/super-io.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/super-io.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/super.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/super.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/super_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/sysfs.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/sysfs.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/tests.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/tests.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/thread_with_file.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/thread_with_file.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/thread_with_file_types.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/trace.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/trace.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/two_state_shared_lock.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/two_state_shared_lock.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/util.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/util.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/varint.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/varint.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/vstructs.h (100%)
 rename {libbcachefs => c_src/libbcachefs}/xattr.c (100%)
 rename {libbcachefs => c_src/libbcachefs}/xattr.h (100%)
 rename {linux => c_src/linux}/atomic64.c (100%)
 rename {linux => c_src/linux}/bio.c (100%)
 rename {linux => c_src/linux}/blkdev.c (100%)
 rename {linux => c_src/linux}/closure.c (100%)
 rename {linux => c_src/linux}/crc64.c (100%)
 rename {linux => c_src/linux}/crc64table.h (100%)
 rename {linux => c_src/linux}/crypto/api.c (100%)
 rename {linux => c_src/linux}/crypto/chacha20_generic.c (100%)
 rename {linux => c_src/linux}/crypto/poly1305_generic.c (100%)
 rename {linux => c_src/linux}/crypto/sha256_generic.c (100%)
 rename {linux => c_src/linux}/fs.c (100%)
 rename {linux => c_src/linux}/generic-radix-tree.c (100%)
 rename {linux => c_src/linux}/int_sqrt.c (100%)
 rename {linux => c_src/linux}/kstrtox.c (100%)
 rename {linux => c_src/linux}/kstrtox.h (100%)
 rename {linux => c_src/linux}/kthread.c (100%)
 rename {linux => c_src/linux}/llist.c (100%)
 rename {linux => c_src/linux}/mempool.c (100%)
 rename {linux => c_src/linux}/preempt.c (100%)
 rename {linux => c_src/linux}/ratelimit.c (100%)
 rename {linux => c_src/linux}/rhashtable.c (100%)
 rename {linux => c_src/linux}/sched.c (100%)
 rename {linux => c_src/linux}/semaphore.c (100%)
 rename {linux => c_src/linux}/seq_buf.c (100%)
 rename {linux => c_src/linux}/shrinker.c (100%)
 rename {linux => c_src/linux}/siphash.c (100%)
 rename {linux => c_src/linux}/string.c (100%)
 rename {linux => c_src/linux}/string_helpers.c (100%)
 rename {linux => c_src/linux}/timer.c (100%)
 rename {linux => c_src/linux}/wait.c (100%)
 rename {linux => c_src/linux}/workqueue.c (100%)
 rename {linux => c_src/linux}/xxhash.c (100%)
 rename {linux => c_src/linux}/zstd_compress_module.c (100%)
 rename {linux => c_src/linux}/zstd_decompress_module.c (100%)
 rename qcow2.c => c_src/qcow2.c (100%)
 rename qcow2.h => c_src/qcow2.h (100%)
 rename {raid => c_src/raid}/COPYING (100%)
 rename {raid => c_src/raid}/check.c (100%)
 rename {raid => c_src/raid}/combo.h (100%)
 rename {raid => c_src/raid}/cpu.h (100%)
 rename {raid => c_src/raid}/gf.h (100%)
 rename {raid => c_src/raid}/helper.c (100%)
 rename {raid => c_src/raid}/helper.h (100%)
 rename {raid => c_src/raid}/int.c (100%)
 rename {raid => c_src/raid}/internal.h (100%)
 rename {raid => c_src/raid}/intz.c (100%)
 rename {raid => c_src/raid}/memory.c (100%)
 rename {raid => c_src/raid}/memory.h (100%)
 rename {raid => c_src/raid}/module.c (100%)
 rename {raid => c_src/raid}/raid.c (100%)
 rename {raid => c_src/raid}/raid.h (100%)
 rename {raid => c_src/raid}/tables.c (100%)
 rename {raid => c_src/raid}/tag.c (100%)
 rename {raid => c_src/raid}/test.c (100%)
 rename {raid => c_src/raid}/test.h (100%)
 rename {raid => c_src/raid}/x86.c (100%)
 rename {raid => c_src/raid}/x86z.c (100%)
 rename tools-util.c => c_src/tools-util.c (100%)
 rename tools-util.h => c_src/tools-util.h (100%)
 delete mode 100644 rust-src/.gitignore
 delete mode 100644 rust-src/README.md
 delete mode 100644 rust-src/bch_bindgen/src/libbcachefs_wrapper.h
 delete mode 100644 rust-src/src/cmd_main.rs
 delete mode 100644 rust-src/src/lib.rs
 rename rust-src/rustfmt.toml => rustfmt.toml (100%)
 create mode 100644 src/bcachefs.rs
 rename {rust-src/src => src/commands}/cmd_completions.rs (84%)
 rename {rust-src/src => src/commands}/cmd_list.rs (98%)
 rename {rust-src/src => src/commands}/cmd_mount.rs (94%)
 rename {rust-src/src => src/commands}/logger.rs (100%)
 create mode 100644 src/commands/mod.rs
 rename {rust-src/src => src}/key.rs (100%)

-- 
2.43.0

