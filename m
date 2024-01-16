Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A019B10A05
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 06:41:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BpG+jodL"
Received: by mail-io1-f50.google.com with SMTP id ca18e2360f4ac-7baa8097064so446876039f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 15 Jan 2024 22:41:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705387310; x=1705992110; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WIzgbwasdF+gf9hK2H6yI8QnuXq4azT/SXNYgNC0bKY=;
        b=BpG+jodLe9h2c7O+oRTHyfGZhY6HTTFRHb4TpltHztsX3u9ckDGtvvrD4ZpYXHK84U
         6V59mmbejU9ptX71CFVrlmaY2vXtU432FA4rJ7cYzeFD5sWvuFim2qIAU8G3mBm4sBYV
         ZG7KARB3Kgzcm+6z4UBTXUSrXRJaHnWxli8T/CVh8B9vLZMafSbntlu5z3Qwe2d5B/Vc
         d3F8TCzd7Vd1MXPzsu+JjaYnsZzMEoFwFlNHlLjJR8iovc3CeY+ROpX2g+NFQwmNWB+E
         ZR7f2zjFtMI0p4nfSRU+iZMsEAVtSVpwvGfcj5KC795QiY4s30DZSdbxmJLqEM5ekO/C
         z5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705387310; x=1705992110;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WIzgbwasdF+gf9hK2H6yI8QnuXq4azT/SXNYgNC0bKY=;
        b=ZsRi5QKciPQM46M1vcSvL42+Rgq2QhOBfeTHlwix6PRjRjNS9lRGu4tvBkdnsEPzt6
         njSsoZX4EEcVlpCQ6RupM/6XgO1OtuQB1FO+tHRFXbTCOHNTiWJNXCfiIyB82+TArcKI
         4VHqzrkMEIdVJGf/0JkbkKEeUSBMHO6LoQ+9cQlsGOkJ40RIniPBA7tPS9NEcHA/7SJ/
         OvrrLc/Va1MwArpmvCT11zIirO3MZIBYndQJXQj7hA4uoi7lZ7IbmtEytN9NSji1MO05
         GNbb37URaXCZjNDZg/kmmR+nRaZ76U3w9Cfxm/3go3M39+Y4/v04tU464opvXvPgLUgL
         jQew==
X-Gm-Message-State: AOJu0YzIN64uKNFSYTh1Vr3/ZKKh0MvYnC0cXIceJwW1bqm2jnGjKUGl
	N/jHKcUIJ1Roa07Db0Jn0RCu5nckyaUGzA==
X-Google-Smtp-Source: AGHT+IGF4zeTALx4gJoLi+ZLML31U2bUckQ0JF+uE7yASM+fDbhCmqykQN8fPlnWoho0QDtG/dq4IQ==
X-Received: by 2002:a05:6602:17:b0:7be:f39e:851f with SMTP id b23-20020a056602001700b007bef39e851fmr7097840ioa.17.1705387309222;
        Mon, 15 Jan 2024 22:41:49 -0800 (PST)
Received: from fedora-laptop.hsd1.nm.comcast.net (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id t24-20020a6bdb18000000b007bf3d8f13c6sm1124309ioc.6.2024.01.15.22.41.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jan 2024 22:41:48 -0800 (PST)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: kent.overstreet@linux.dev,
	linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH TOOLS v2 3/3] move Rust sources to top level, C sources into c_src
Date: Mon, 15 Jan 2024 23:41:02 -0700
Message-ID: <20240116064102.193643-4-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240116064102.193643-1-tahbertschinger@gmail.com>
References: <20240116064102.193643-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This moves the Rust sources out of rust_src/ and into the top level.
Running the bcachefs executable out of the development tree is now:

$ ./target/release/bcachefs command
or
$ cargo run --profile release -- command

instead of "./bcachefs command".

Building and installing is still:

$ make && make install

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 .github/workflows/build-packages.yml          |  2 +-
 .gitignore                                    | 10 +++
 rust-src/Cargo.lock => Cargo.lock             |  0
 rust-src/Cargo.toml => Cargo.toml             |  0
 Makefile                                      | 23 ++++---
 .../bch_bindgen => bch_bindgen}/.gitignore    |  0
 .../bch_bindgen => bch_bindgen}/Cargo.lock    |  0
 .../bch_bindgen => bch_bindgen}/Cargo.toml    |  0
 .../bch_bindgen => bch_bindgen}/build.rs      |  3 +-
 .../bch_bindgen => bch_bindgen}/rustfmt.toml  |  0
 .../src/bcachefs.rs                           |  0
 .../bch_bindgen => bch_bindgen}/src/bkey.rs   |  0
 .../bch_bindgen => bch_bindgen}/src/btree.rs  |  0
 .../src/errcode.rs                            |  0
 .../bch_bindgen => bch_bindgen}/src/fs.rs     |  0
 .../src/keyutils.rs                           |  0
 .../src/keyutils_wrapper.h                    |  0
 .../bch_bindgen => bch_bindgen}/src/lib.rs    |  0
 bch_bindgen/src/libbcachefs_wrapper.h         | 22 +++++++
 .../bch_bindgen => bch_bindgen}/src/opts.rs   |  0
 .../bch_bindgen => bch_bindgen}/src/rs.rs     |  0
 build.nix                                     |  4 +-
 rust-src/build.rs => build.rs                 |  4 +-
 bcachefs.c => c_src/bcachefs.c                |  0
 {ccan => c_src/ccan}/array_size/LICENSE       |  0
 {ccan => c_src/ccan}/array_size/_info         |  0
 {ccan => c_src/ccan}/array_size/array_size.h  |  0
 {ccan => c_src/ccan}/build_assert/LICENSE     |  0
 {ccan => c_src/ccan}/build_assert/_info       |  0
 .../ccan}/build_assert/build_assert.h         |  0
 {ccan => c_src/ccan}/compiler/LICENSE         |  0
 {ccan => c_src/ccan}/compiler/_info           |  0
 {ccan => c_src/ccan}/compiler/compiler.h      |  0
 cmd_assemble.c => c_src/cmd_assemble.c        |  0
 cmd_attr.c => c_src/cmd_attr.c                |  0
 cmd_counters.c => c_src/cmd_counters.c        |  0
 cmd_data.c => c_src/cmd_data.c                |  0
 cmd_device.c => c_src/cmd_device.c            |  0
 cmd_dump.c => c_src/cmd_dump.c                |  0
 cmd_format.c => c_src/cmd_format.c            |  0
 cmd_fs.c => c_src/cmd_fs.c                    |  0
 cmd_fsck.c => c_src/cmd_fsck.c                |  0
 cmd_fusemount.c => c_src/cmd_fusemount.c      |  0
 cmd_key.c => c_src/cmd_key.c                  |  0
 .../cmd_kill_btree_node.c                     |  0
 .../cmd_list_journal.c                        |  0
 cmd_migrate.c => c_src/cmd_migrate.c          |  0
 cmd_option.c => c_src/cmd_option.c            |  0
 cmd_run.c => c_src/cmd_run.c                  |  0
 cmd_subvolume.c => c_src/cmd_subvolume.c      |  0
 cmd_version.c => c_src/cmd_version.c          |  0
 cmds.h => c_src/cmds.h                        |  0
 config.h => c_src/config.h                    |  0
 crypto.c => c_src/crypto.c                    |  0
 crypto.h => c_src/crypto.h                    |  0
 {include => c_src/include}/asm/page.h         |  0
 {include => c_src/include}/asm/unaligned.h    |  0
 {include => c_src/include}/crypto/algapi.h    |  0
 {include => c_src/include}/crypto/chacha.h    |  0
 {include => c_src/include}/crypto/hash.h      |  0
 {include => c_src/include}/crypto/poly1305.h  |  0
 {include => c_src/include}/crypto/sha2.h      |  0
 {include => c_src/include}/crypto/skcipher.h  |  0
 {include => c_src/include}/keys/user-type.h   |  0
 {include => c_src/include}/linux/atomic.h     |  0
 .../include}/linux/backing-dev-defs.h         |  0
 .../include}/linux/backing-dev.h              |  0
 {include => c_src/include}/linux/bio.h        |  0
 .../include}/linux/bit_spinlock.h             |  0
 {include => c_src/include}/linux/bitmap.h     |  0
 {include => c_src/include}/linux/bitops.h     |  0
 {include => c_src/include}/linux/blk_types.h  |  0
 {include => c_src/include}/linux/blkdev.h     |  0
 {include => c_src/include}/linux/bsearch.h    |  0
 {include => c_src/include}/linux/bug.h        |  0
 {include => c_src/include}/linux/bvec.h       |  0
 {include => c_src/include}/linux/byteorder.h  |  0
 {include => c_src/include}/linux/cache.h      |  0
 {include => c_src/include}/linux/closure.h    |  0
 {include => c_src/include}/linux/compiler.h   |  0
 {include => c_src/include}/linux/completion.h |  0
 {include => c_src/include}/linux/console.h    |  0
 {include => c_src/include}/linux/cpumask.h    |  0
 {include => c_src/include}/linux/crc32c.h     |  0
 {include => c_src/include}/linux/crc64.h      |  0
 {include => c_src/include}/linux/crypto.h     |  0
 {include => c_src/include}/linux/ctype.h      |  0
 {include => c_src/include}/linux/dcache.h     |  0
 {include => c_src/include}/linux/debugfs.h    |  0
 {include => c_src/include}/linux/device.h     |  0
 .../include}/linux/dynamic_fault.h            |  0
 {include => c_src/include}/linux/err.h        |  0
 {include => c_src/include}/linux/errname.h    |  0
 {include => c_src/include}/linux/export.h     |  0
 {include => c_src/include}/linux/freezer.h    |  0
 .../include}/linux/generic-radix-tree.h       |  0
 {include => c_src/include}/linux/genhd.h      |  0
 {include => c_src/include}/linux/gfp.h        |  0
 {include => c_src/include}/linux/hash.h       |  0
 {include => c_src/include}/linux/idr.h        |  0
 {include => c_src/include}/linux/ioprio.h     |  0
 {include => c_src/include}/linux/jhash.h      |  0
 {include => c_src/include}/linux/jiffies.h    |  0
 {include => c_src/include}/linux/kernel.h     |  0
 {include => c_src/include}/linux/key.h        |  0
 {include => c_src/include}/linux/kmemleak.h   |  0
 {include => c_src/include}/linux/kobject.h    |  0
 {include => c_src/include}/linux/kthread.h    |  0
 {include => c_src/include}/linux/list.h       |  0
 {include => c_src/include}/linux/list_nulls.h |  0
 {include => c_src/include}/linux/llist.h      |  0
 {include => c_src/include}/linux/lockdep.h    |  0
 {include => c_src/include}/linux/log2.h       |  0
 {include => c_src/include}/linux/lz4.h        |  0
 {include => c_src/include}/linux/math.h       |  0
 {include => c_src/include}/linux/math64.h     |  0
 {include => c_src/include}/linux/mempool.h    |  0
 {include => c_src/include}/linux/minmax.h     |  0
 {include => c_src/include}/linux/mm.h         |  0
 {include => c_src/include}/linux/module.h     |  0
 {include => c_src/include}/linux/mutex.h      |  0
 {include => c_src/include}/linux/osq_lock.h   |  0
 {include => c_src/include}/linux/overflow.h   |  0
 {include => c_src/include}/linux/page.h       |  0
 .../include}/linux/percpu-refcount.h          |  0
 .../include}/linux/percpu-rwsem.h             |  0
 {include => c_src/include}/linux/percpu.h     |  0
 {include => c_src/include}/linux/poison.h     |  0
 {include => c_src/include}/linux/posix_acl.h  |  0
 .../include}/linux/posix_acl_xattr.h          |  0
 {include => c_src/include}/linux/prandom.h    |  0
 {include => c_src/include}/linux/preempt.h    |  0
 {include => c_src/include}/linux/prefetch.h   |  0
 .../include}/linux/pretty-printers.h          |  0
 {include => c_src/include}/linux/printk.h     |  0
 {include => c_src/include}/linux/random.h     |  0
 {include => c_src/include}/linux/ratelimit.h  |  0
 {include => c_src/include}/linux/rculist.h    |  0
 {include => c_src/include}/linux/rcupdate.h   |  0
 {include => c_src/include}/linux/refcount.h   |  0
 .../include}/linux/rhashtable-types.h         |  0
 {include => c_src/include}/linux/rhashtable.h |  0
 {include => c_src/include}/linux/rwsem.h      |  0
 .../include}/linux/scatterlist.h              |  0
 {include => c_src/include}/linux/sched.h      |  0
 .../include}/linux/sched/clock.h              |  0
 .../include}/linux/sched/cputime.h            |  0
 .../include}/linux/sched/debug.h              |  0
 {include => c_src/include}/linux/sched/mm.h   |  0
 {include => c_src/include}/linux/sched/rt.h   |  0
 .../include}/linux/sched/signal.h             |  0
 {include => c_src/include}/linux/sched/task.h |  0
 .../include}/linux/sched/task_stack.h         |  0
 {include => c_src/include}/linux/semaphore.h  |  0
 {include => c_src/include}/linux/seq_buf.h    |  0
 {include => c_src/include}/linux/seq_file.h   |  0
 {include => c_src/include}/linux/seqlock.h    |  0
 {include => c_src/include}/linux/shrinker.h   |  0
 {include => c_src/include}/linux/siphash.h    |  0
 {include => c_src/include}/linux/slab.h       |  0
 {include => c_src/include}/linux/sort.h       |  0
 {include => c_src/include}/linux/spinlock.h   |  0
 {include => c_src/include}/linux/srcu.h       |  0
 {include => c_src/include}/linux/stat.h       |  0
 {include => c_src/include}/linux/string.h     |  0
 .../include}/linux/string_helpers.h           |  0
 {include => c_src/include}/linux/sysfs.h      |  0
 {include => c_src/include}/linux/time64.h     |  0
 {include => c_src/include}/linux/timer.h      |  0
 {include => c_src/include}/linux/tracepoint.h |  0
 {include => c_src/include}/linux/typecheck.h  |  0
 {include => c_src/include}/linux/types.h      |  0
 .../include}/linux/unaligned/be_byteshift.h   |  0
 .../include}/linux/unaligned/be_struct.h      |  0
 .../include}/linux/unaligned/generic.h        |  0
 .../include}/linux/unaligned/le_byteshift.h   |  0
 .../include}/linux/unaligned/le_struct.h      |  0
 .../include}/linux/unaligned/packed_struct.h  |  0
 {include => c_src/include}/linux/uuid.h       |  0
 {include => c_src/include}/linux/vmalloc.h    |  0
 {include => c_src/include}/linux/wait.h       |  0
 {include => c_src/include}/linux/workqueue.h  |  0
 {include => c_src/include}/linux/xattr.h      |  0
 {include => c_src/include}/linux/xxhash.h     |  0
 {include => c_src/include}/linux/zlib.h       |  0
 {include => c_src/include}/linux/zstd.h       |  0
 .../include}/linux/zstd_errors.h              |  0
 .../include}/trace/define_trace.h             |  0
 .../include}/trace/events/lock.h              |  0
 {include => c_src/include}/uapi/linux/xattr.h |  0
 libbcachefs.c => c_src/libbcachefs.c          |  0
 libbcachefs.h => c_src/libbcachefs.h          |  0
 {libbcachefs => c_src/libbcachefs}/acl.c      |  0
 {libbcachefs => c_src/libbcachefs}/acl.h      |  0
 .../libbcachefs}/alloc_background.c           |  0
 .../libbcachefs}/alloc_background.h           |  0
 .../libbcachefs}/alloc_foreground.c           |  0
 .../libbcachefs}/alloc_foreground.h           |  0
 .../libbcachefs}/alloc_types.h                |  0
 .../libbcachefs}/backpointers.c               |  0
 .../libbcachefs}/backpointers.h               |  0
 {libbcachefs => c_src/libbcachefs}/bbpos.h    |  0
 .../libbcachefs}/bbpos_types.h                |  0
 {libbcachefs => c_src/libbcachefs}/bcachefs.h |  0
 .../libbcachefs}/bcachefs_format.h            |  0
 .../libbcachefs}/bcachefs_ioctl.h             |  0
 {libbcachefs => c_src/libbcachefs}/bkey.c     |  0
 {libbcachefs => c_src/libbcachefs}/bkey.h     |  0
 {libbcachefs => c_src/libbcachefs}/bkey_buf.h |  0
 {libbcachefs => c_src/libbcachefs}/bkey_cmp.h |  0
 .../libbcachefs}/bkey_methods.c               |  0
 .../libbcachefs}/bkey_methods.h               |  0
 .../libbcachefs}/bkey_sort.c                  |  0
 .../libbcachefs}/bkey_sort.h                  |  0
 {libbcachefs => c_src/libbcachefs}/bset.c     |  0
 {libbcachefs => c_src/libbcachefs}/bset.h     |  0
 .../libbcachefs}/btree_cache.c                |  0
 .../libbcachefs}/btree_cache.h                |  0
 {libbcachefs => c_src/libbcachefs}/btree_gc.c |  0
 {libbcachefs => c_src/libbcachefs}/btree_gc.h |  0
 {libbcachefs => c_src/libbcachefs}/btree_io.c |  0
 {libbcachefs => c_src/libbcachefs}/btree_io.h |  0
 .../libbcachefs}/btree_iter.c                 |  0
 .../libbcachefs}/btree_iter.h                 |  0
 .../libbcachefs}/btree_journal_iter.c         |  0
 .../libbcachefs}/btree_journal_iter.h         |  0
 .../libbcachefs}/btree_key_cache.c            |  0
 .../libbcachefs}/btree_key_cache.h            |  0
 .../libbcachefs}/btree_key_cache_types.h      |  0
 .../libbcachefs}/btree_locking.c              |  0
 .../libbcachefs}/btree_locking.h              |  0
 .../libbcachefs}/btree_trans_commit.c         |  0
 .../libbcachefs}/btree_types.h                |  0
 .../libbcachefs}/btree_update.c               |  0
 .../libbcachefs}/btree_update.h               |  0
 .../libbcachefs}/btree_update_interior.c      |  0
 .../libbcachefs}/btree_update_interior.h      |  0
 .../libbcachefs}/btree_write_buffer.c         |  0
 .../libbcachefs}/btree_write_buffer.h         |  0
 .../libbcachefs}/btree_write_buffer_types.h   |  0
 {libbcachefs => c_src/libbcachefs}/buckets.c  |  0
 {libbcachefs => c_src/libbcachefs}/buckets.h  |  0
 .../libbcachefs}/buckets_types.h              |  0
 .../buckets_waiting_for_journal.c             |  0
 .../buckets_waiting_for_journal.h             |  0
 .../buckets_waiting_for_journal_types.h       |  0
 {libbcachefs => c_src/libbcachefs}/chardev.c  |  0
 {libbcachefs => c_src/libbcachefs}/chardev.h  |  0
 {libbcachefs => c_src/libbcachefs}/checksum.c |  0
 {libbcachefs => c_src/libbcachefs}/checksum.h |  0
 {libbcachefs => c_src/libbcachefs}/clock.c    |  0
 {libbcachefs => c_src/libbcachefs}/clock.h    |  0
 .../libbcachefs}/clock_types.h                |  0
 {libbcachefs => c_src/libbcachefs}/compress.c |  0
 {libbcachefs => c_src/libbcachefs}/compress.h |  0
 {libbcachefs => c_src/libbcachefs}/counters.c |  0
 {libbcachefs => c_src/libbcachefs}/counters.h |  0
 {libbcachefs => c_src/libbcachefs}/darray.c   |  0
 {libbcachefs => c_src/libbcachefs}/darray.h   |  0
 .../libbcachefs}/data_update.c                |  0
 .../libbcachefs}/data_update.h                |  0
 {libbcachefs => c_src/libbcachefs}/debug.c    |  0
 {libbcachefs => c_src/libbcachefs}/debug.h    |  0
 {libbcachefs => c_src/libbcachefs}/dirent.c   |  0
 {libbcachefs => c_src/libbcachefs}/dirent.h   |  0
 .../libbcachefs}/disk_groups.c                |  0
 .../libbcachefs}/disk_groups.h                |  0
 .../libbcachefs}/disk_groups_types.h          |  0
 {libbcachefs => c_src/libbcachefs}/ec.c       |  0
 {libbcachefs => c_src/libbcachefs}/ec.h       |  0
 {libbcachefs => c_src/libbcachefs}/ec_types.h |  0
 {libbcachefs => c_src/libbcachefs}/errcode.c  |  0
 {libbcachefs => c_src/libbcachefs}/errcode.h  |  0
 {libbcachefs => c_src/libbcachefs}/error.c    |  0
 {libbcachefs => c_src/libbcachefs}/error.h    |  0
 .../libbcachefs}/extent_update.c              |  0
 .../libbcachefs}/extent_update.h              |  0
 {libbcachefs => c_src/libbcachefs}/extents.c  |  0
 {libbcachefs => c_src/libbcachefs}/extents.h  |  0
 .../libbcachefs}/extents_types.h              |  0
 .../libbcachefs}/eytzinger.h                  |  0
 {libbcachefs => c_src/libbcachefs}/fifo.h     |  0
 .../libbcachefs}/fs-common.c                  |  0
 .../libbcachefs}/fs-common.h                  |  0
 .../libbcachefs}/fs-io-buffered.c             |  0
 .../libbcachefs}/fs-io-buffered.h             |  0
 .../libbcachefs}/fs-io-direct.c               |  0
 .../libbcachefs}/fs-io-direct.h               |  0
 .../libbcachefs}/fs-io-pagecache.c            |  0
 .../libbcachefs}/fs-io-pagecache.h            |  0
 {libbcachefs => c_src/libbcachefs}/fs-io.c    |  0
 {libbcachefs => c_src/libbcachefs}/fs-io.h    |  0
 {libbcachefs => c_src/libbcachefs}/fs-ioctl.c |  0
 {libbcachefs => c_src/libbcachefs}/fs-ioctl.h |  0
 {libbcachefs => c_src/libbcachefs}/fs.c       |  0
 {libbcachefs => c_src/libbcachefs}/fs.h       |  0
 {libbcachefs => c_src/libbcachefs}/fsck.c     |  0
 {libbcachefs => c_src/libbcachefs}/fsck.h     |  0
 {libbcachefs => c_src/libbcachefs}/inode.c    |  0
 {libbcachefs => c_src/libbcachefs}/inode.h    |  0
 {libbcachefs => c_src/libbcachefs}/io_misc.c  |  0
 {libbcachefs => c_src/libbcachefs}/io_misc.h  |  0
 {libbcachefs => c_src/libbcachefs}/io_read.c  |  0
 {libbcachefs => c_src/libbcachefs}/io_read.h  |  0
 {libbcachefs => c_src/libbcachefs}/io_write.c |  0
 {libbcachefs => c_src/libbcachefs}/io_write.h |  0
 .../libbcachefs}/io_write_types.h             |  0
 {libbcachefs => c_src/libbcachefs}/journal.c  |  0
 {libbcachefs => c_src/libbcachefs}/journal.h  |  0
 .../libbcachefs}/journal_io.c                 |  0
 .../libbcachefs}/journal_io.h                 |  0
 .../libbcachefs}/journal_reclaim.c            |  0
 .../libbcachefs}/journal_reclaim.h            |  0
 .../libbcachefs}/journal_sb.c                 |  0
 .../libbcachefs}/journal_sb.h                 |  0
 .../libbcachefs}/journal_seq_blacklist.c      |  0
 .../libbcachefs}/journal_seq_blacklist.h      |  0
 .../libbcachefs}/journal_types.h              |  0
 {libbcachefs => c_src/libbcachefs}/keylist.c  |  0
 {libbcachefs => c_src/libbcachefs}/keylist.h  |  0
 .../libbcachefs}/keylist_types.h              |  0
 .../libbcachefs}/logged_ops.c                 |  0
 .../libbcachefs}/logged_ops.h                 |  0
 {libbcachefs => c_src/libbcachefs}/lru.c      |  0
 {libbcachefs => c_src/libbcachefs}/lru.h      |  0
 .../libbcachefs}/mean_and_variance.c          |  0
 .../libbcachefs}/mean_and_variance.h          |  0
 {libbcachefs => c_src/libbcachefs}/migrate.c  |  0
 {libbcachefs => c_src/libbcachefs}/migrate.h  |  0
 {libbcachefs => c_src/libbcachefs}/move.c     |  0
 {libbcachefs => c_src/libbcachefs}/move.h     |  0
 .../libbcachefs}/move_types.h                 |  0
 {libbcachefs => c_src/libbcachefs}/movinggc.c |  0
 {libbcachefs => c_src/libbcachefs}/movinggc.h |  0
 .../libbcachefs}/nocow_locking.c              |  0
 .../libbcachefs}/nocow_locking.h              |  0
 .../libbcachefs}/nocow_locking_types.h        |  0
 {libbcachefs => c_src/libbcachefs}/opts.c     |  0
 {libbcachefs => c_src/libbcachefs}/opts.h     |  0
 {libbcachefs => c_src/libbcachefs}/printbuf.c |  0
 {libbcachefs => c_src/libbcachefs}/printbuf.h |  0
 {libbcachefs => c_src/libbcachefs}/quota.c    |  0
 {libbcachefs => c_src/libbcachefs}/quota.h    |  0
 .../libbcachefs}/quota_types.h                |  0
 .../libbcachefs}/rebalance.c                  |  0
 .../libbcachefs}/rebalance.h                  |  0
 .../libbcachefs}/rebalance_types.h            |  0
 {libbcachefs => c_src/libbcachefs}/recovery.c |  0
 {libbcachefs => c_src/libbcachefs}/recovery.h |  0
 .../libbcachefs}/recovery_types.h             |  0
 {libbcachefs => c_src/libbcachefs}/reflink.c  |  0
 {libbcachefs => c_src/libbcachefs}/reflink.h  |  0
 {libbcachefs => c_src/libbcachefs}/replicas.c |  0
 {libbcachefs => c_src/libbcachefs}/replicas.h |  0
 .../libbcachefs}/replicas_types.h             |  0
 {libbcachefs => c_src/libbcachefs}/sb-clean.c |  0
 {libbcachefs => c_src/libbcachefs}/sb-clean.h |  0
 .../libbcachefs}/sb-downgrade.c               |  0
 .../libbcachefs}/sb-downgrade.h               |  0
 .../libbcachefs}/sb-errors.c                  |  0
 .../libbcachefs}/sb-errors.h                  |  0
 .../libbcachefs}/sb-errors_types.h            |  0
 .../libbcachefs}/sb-members.c                 |  0
 .../libbcachefs}/sb-members.h                 |  0
 {libbcachefs => c_src/libbcachefs}/seqmutex.h |  0
 {libbcachefs => c_src/libbcachefs}/siphash.c  |  0
 {libbcachefs => c_src/libbcachefs}/siphash.h  |  0
 {libbcachefs => c_src/libbcachefs}/six.c      |  0
 {libbcachefs => c_src/libbcachefs}/six.h      |  0
 {libbcachefs => c_src/libbcachefs}/snapshot.c |  0
 {libbcachefs => c_src/libbcachefs}/snapshot.h |  0
 {libbcachefs => c_src/libbcachefs}/str_hash.h |  0
 .../libbcachefs}/subvolume.c                  |  0
 .../libbcachefs}/subvolume.h                  |  0
 .../libbcachefs}/subvolume_types.h            |  0
 {libbcachefs => c_src/libbcachefs}/super-io.c |  0
 {libbcachefs => c_src/libbcachefs}/super-io.h |  0
 {libbcachefs => c_src/libbcachefs}/super.c    |  0
 {libbcachefs => c_src/libbcachefs}/super.h    |  0
 .../libbcachefs}/super_types.h                |  0
 {libbcachefs => c_src/libbcachefs}/sysfs.c    |  0
 {libbcachefs => c_src/libbcachefs}/sysfs.h    |  0
 {libbcachefs => c_src/libbcachefs}/tests.c    |  0
 {libbcachefs => c_src/libbcachefs}/tests.h    |  0
 .../libbcachefs}/thread_with_file.c           |  0
 .../libbcachefs}/thread_with_file.h           |  0
 .../libbcachefs}/thread_with_file_types.h     |  0
 {libbcachefs => c_src/libbcachefs}/trace.c    |  0
 {libbcachefs => c_src/libbcachefs}/trace.h    |  0
 .../libbcachefs}/two_state_shared_lock.c      |  0
 .../libbcachefs}/two_state_shared_lock.h      |  0
 {libbcachefs => c_src/libbcachefs}/util.c     |  0
 {libbcachefs => c_src/libbcachefs}/util.h     |  0
 {libbcachefs => c_src/libbcachefs}/varint.c   |  0
 {libbcachefs => c_src/libbcachefs}/varint.h   |  0
 {libbcachefs => c_src/libbcachefs}/vstructs.h |  0
 {libbcachefs => c_src/libbcachefs}/xattr.c    |  0
 {libbcachefs => c_src/libbcachefs}/xattr.h    |  0
 {linux => c_src/linux}/atomic64.c             |  0
 {linux => c_src/linux}/bio.c                  |  0
 {linux => c_src/linux}/blkdev.c               |  0
 {linux => c_src/linux}/closure.c              |  0
 {linux => c_src/linux}/crc64.c                |  0
 {linux => c_src/linux}/crc64table.h           |  0
 {linux => c_src/linux}/crypto/api.c           |  0
 .../linux}/crypto/chacha20_generic.c          |  0
 .../linux}/crypto/poly1305_generic.c          |  0
 .../linux}/crypto/sha256_generic.c            |  0
 {linux => c_src/linux}/fs.c                   |  0
 {linux => c_src/linux}/generic-radix-tree.c   |  0
 {linux => c_src/linux}/int_sqrt.c             |  0
 {linux => c_src/linux}/kstrtox.c              |  0
 {linux => c_src/linux}/kstrtox.h              |  0
 {linux => c_src/linux}/kthread.c              |  0
 {linux => c_src/linux}/llist.c                |  0
 {linux => c_src/linux}/mempool.c              |  0
 {linux => c_src/linux}/preempt.c              |  0
 {linux => c_src/linux}/ratelimit.c            |  0
 {linux => c_src/linux}/rhashtable.c           |  0
 {linux => c_src/linux}/sched.c                |  0
 {linux => c_src/linux}/semaphore.c            |  0
 {linux => c_src/linux}/seq_buf.c              |  0
 {linux => c_src/linux}/shrinker.c             |  0
 {linux => c_src/linux}/siphash.c              |  0
 {linux => c_src/linux}/string.c               |  0
 {linux => c_src/linux}/string_helpers.c       |  0
 {linux => c_src/linux}/timer.c                |  0
 {linux => c_src/linux}/wait.c                 |  0
 {linux => c_src/linux}/workqueue.c            |  0
 {linux => c_src/linux}/xxhash.c               |  0
 {linux => c_src/linux}/zstd_compress_module.c |  0
 .../linux}/zstd_decompress_module.c           |  0
 qcow2.c => c_src/qcow2.c                      |  0
 qcow2.h => c_src/qcow2.h                      |  0
 {raid => c_src/raid}/COPYING                  |  0
 {raid => c_src/raid}/check.c                  |  0
 {raid => c_src/raid}/combo.h                  |  0
 {raid => c_src/raid}/cpu.h                    |  0
 {raid => c_src/raid}/gf.h                     |  0
 {raid => c_src/raid}/helper.c                 |  0
 {raid => c_src/raid}/helper.h                 |  0
 {raid => c_src/raid}/int.c                    |  0
 {raid => c_src/raid}/internal.h               |  0
 {raid => c_src/raid}/intz.c                   |  0
 {raid => c_src/raid}/memory.c                 |  0
 {raid => c_src/raid}/memory.h                 |  0
 {raid => c_src/raid}/module.c                 |  0
 {raid => c_src/raid}/raid.c                   |  0
 {raid => c_src/raid}/raid.h                   |  0
 {raid => c_src/raid}/tables.c                 |  0
 {raid => c_src/raid}/tag.c                    |  0
 {raid => c_src/raid}/test.c                   |  0
 {raid => c_src/raid}/test.h                   |  0
 {raid => c_src/raid}/x86.c                    |  0
 {raid => c_src/raid}/x86z.c                   |  0
 tools-util.c => c_src/tools-util.c            |  0
 tools-util.h => c_src/tools-util.h            |  0
 make-release-tarball.sh                       |  4 +-
 rust-src/.gitignore                           | 15 -----
 rust-src/README.md                            | 62 -------------------
 .../bch_bindgen/src/libbcachefs_wrapper.h     | 22 -------
 rust-src/rustfmt.toml => rustfmt.toml         |  0
 {rust-src/src => src}/bcachefs.rs             |  0
 .../src => src}/commands/cmd_completions.rs   |  0
 {rust-src/src => src}/commands/cmd_list.rs    |  0
 {rust-src/src => src}/commands/cmd_mount.rs   |  0
 {rust-src/src => src}/commands/logger.rs      |  0
 {rust-src/src => src}/commands/mod.rs         |  0
 {rust-src/src => src}/key.rs                  |  0
 tests/util.py                                 |  2 +-
 470 files changed, 52 insertions(+), 121 deletions(-)
 rename rust-src/Cargo.lock => Cargo.lock (100%)
 rename rust-src/Cargo.toml => Cargo.toml (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/.gitignore (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/Cargo.lock (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/Cargo.toml (100%)
 rename {rust-src/bch_bindgen => bch_bindgen}/build.rs (96%)
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
 rename rust-src/build.rs => build.rs (86%)
 rename bcachefs.c => c_src/bcachefs.c (100%)
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
 rename cmds.h => c_src/cmds.h (100%)
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
 rename rust-src/rustfmt.toml => rustfmt.toml (100%)
 rename {rust-src/src => src}/bcachefs.rs (100%)
 rename {rust-src/src => src}/commands/cmd_completions.rs (100%)
 rename {rust-src/src => src}/commands/cmd_list.rs (100%)
 rename {rust-src/src => src}/commands/cmd_mount.rs (100%)
 rename {rust-src/src => src}/commands/logger.rs (100%)
 rename {rust-src/src => src}/commands/mod.rs (100%)
 rename {rust-src/src => src}/key.rs (100%)

diff --git a/.github/workflows/build-packages.yml b/.github/workflows/build-packages.yml
index 08a6827..0d134b5 100644
--- a/.github/workflows/build-packages.yml
+++ b/.github/workflows/build-packages.yml
@@ -78,7 +78,7 @@ jobs:
               uuid-dev zlib1g-dev valgrind libudev-dev python3-docutils libclang-dev
       - name: Extract MSRV
         run: |
-          MSRV=$(cargo metadata --format-version 1 --no-deps --manifest-path rust-src/Cargo.toml |
+          MSRV=$(cargo metadata --format-version 1 --no-deps |
                   jq -r '.packages[] | select(.name == "bcachefs-tools") | .rust_version')
           echo "MSRV=$MSRV" >> $GITHUB_ENV
       - name: Install Rust ${{ env.MSRV }} toolchain
diff --git a/.gitignore b/.gitignore
index efd7dc7..cf86eab 100644
--- a/.gitignore
+++ b/.gitignore
@@ -20,3 +20,13 @@ tests/__pycache__/
 !.editorconfig
 
 bcachefs-principles-of-operation.*
+
+# will have compiled files and executables
+debug/
+target/
+
+# These are backup files generated by rustfmt
+**/*.rs.bk
+
+# MSVC Windows builds of rustc generate these, which store debugging information
+*.pdb
diff --git a/rust-src/Cargo.lock b/Cargo.lock
similarity index 100%
rename from rust-src/Cargo.lock
rename to Cargo.lock
diff --git a/rust-src/Cargo.toml b/Cargo.toml
similarity index 100%
rename from rust-src/Cargo.toml
rename to Cargo.toml
diff --git a/Makefile b/Makefile
index d283c7b..4b4762a 100644
--- a/Makefile
+++ b/Makefile
@@ -30,7 +30,7 @@ CFLAGS+=-std=gnu11 -O2 -g -MMD -Wall -fPIC			\
 	-Wno-deprecated-declarations				\
 	-fno-strict-aliasing					\
 	-fno-delete-null-pointer-checks				\
-	-I. -Iinclude -Iraid					\
+	-Ic_src -Ic_src/include					\
 	-D_FILE_OFFSET_BITS=64					\
 	-D_GNU_SOURCE						\
 	-D_LGPL_SOURCE						\
@@ -55,12 +55,11 @@ CARGO_ARGS=${CARGO_TOOLCHAIN}
 CARGO=cargo $(CARGO_ARGS)
 CARGO_PROFILE=release
 # CARGO_PROFILE=debug
-CARGO_MANIFEST=--manifest-path rust-src/Cargo.toml
 
 CARGO_BUILD_ARGS=--$(CARGO_PROFILE)
-CARGO_BUILD=$(CARGO) build $(CARGO_BUILD_ARGS) $(CARGO_MANIFEST)
+CARGO_BUILD=$(CARGO) build $(CARGO_BUILD_ARGS)
 
-CARGO_CLEAN=$(CARGO) clean $(CARGO_CLEAN_ARGS) $(CARGO_MANIFEST)
+CARGO_CLEAN=$(CARGO) clean $(CARGO_CLEAN_ARGS)
 
 include Makefile.compiler
 
@@ -172,13 +171,13 @@ OBJS:=$(SRCS:.c=.o)
 	@echo "    [CC]     $@"
 	$(Q)$(CC) $(CPPFLAGS) $(CFLAGS) -c -o $@ $<
 
-BCACHEFS_DEPS=libbcachefs.a
-RUST_SRCS:=$(shell find rust-src/src rust-src/bch_bindgen/src -type f -iname '*.rs')
+BCACHEFS_DEPS=c_src/libbcachefs.a
+RUST_SRCS:=$(shell find src bch_bindgen/src -type f -iname '*.rs')
 
 bcachefs: $(BCACHEFS_DEPS) $(RUST_SRCS)
-	$(CARGO_BUILD)
+	$(Q)$(CARGO_BUILD)
 
-libbcachefs.a: $(filter-out ./tests/%.o, $(OBJS))
+c_src/libbcachefs.a: $(filter-out ./tests/%.o, $(OBJS))
 	@echo "    [AR]     $@"
 	$(Q)ar -rc $@ $+
 
@@ -201,7 +200,7 @@ cmd_version.o : .version
 install: INITRAMFS_HOOK=$(INITRAMFS_DIR)/hooks/bcachefs
 install: INITRAMFS_SCRIPT=$(INITRAMFS_DIR)/scripts/local-premount/bcachefs
 install: bcachefs $(optional_install)
-	$(INSTALL) -m0755 -D rust-src/target/release/bcachefs -t $(DESTDIR)$(ROOT_SBINDIR)
+	$(INSTALL) -m0755 -D target/release/bcachefs -t $(DESTDIR)$(ROOT_SBINDIR)
 	$(INSTALL) -m0644 -D bcachefs.8    -t $(DESTDIR)$(PREFIX)/share/man/man8/
 	$(INSTALL) -m0755 -D initramfs/script $(DESTDIR)$(INITRAMFS_SCRIPT)
 	$(INSTALL) -m0755 -D initramfs/hook   $(DESTDIR)$(INITRAMFS_HOOK)
@@ -224,7 +223,7 @@ install_systemd: $(systemd_services) $(systemd_libexecfiles)
 .PHONY: clean
 clean:
 	@echo "Cleaning all"
-	$(Q)$(RM) libbcachefs.a tests/test_helper .version *.tar.xz $(OBJS) $(DEPS) $(DOCGENERATED)
+	$(Q)$(RM) c_src/libbcachefs.a tests/test_helper .version *.tar.xz $(OBJS) $(DEPS) $(DOCGENERATED)
 	$(Q)$(CARGO_CLEAN)
 	$(Q)$(RM) -f $(built_scripts)
 
@@ -244,8 +243,8 @@ doc: bcachefs-principles-of-operation.pdf
 
 .PHONY: cargo-update-msrv
 cargo-update-msrv:
-	cargo +nightly generate-lockfile --manifest-path rust-src/Cargo.toml -Zmsrv-policy
-	cargo +nightly generate-lockfile --manifest-path rust-src/bch_bindgen/Cargo.toml -Zmsrv-policy
+	cargo +nightly generate-lockfile -Zmsrv-policy
+	cargo +nightly generate-lockfile --manifest-path bch_bindgen/Cargo.toml -Zmsrv-policy
 
 .PHONY: update-bcachefs-sources
 update-bcachefs-sources:
diff --git a/rust-src/bch_bindgen/.gitignore b/bch_bindgen/.gitignore
similarity index 100%
rename from rust-src/bch_bindgen/.gitignore
rename to bch_bindgen/.gitignore
diff --git a/rust-src/bch_bindgen/Cargo.lock b/bch_bindgen/Cargo.lock
similarity index 100%
rename from rust-src/bch_bindgen/Cargo.lock
rename to bch_bindgen/Cargo.lock
diff --git a/rust-src/bch_bindgen/Cargo.toml b/bch_bindgen/Cargo.toml
similarity index 100%
rename from rust-src/bch_bindgen/Cargo.toml
rename to bch_bindgen/Cargo.toml
diff --git a/rust-src/bch_bindgen/build.rs b/bch_bindgen/build.rs
similarity index 96%
rename from rust-src/bch_bindgen/build.rs
rename to bch_bindgen/build.rs
index d9805a8..facea21 100644
--- a/rust-src/bch_bindgen/build.rs
+++ b/bch_bindgen/build.rs
@@ -19,9 +19,8 @@ fn main() {
         .expect("ENV Var 'CARGO_MANIFEST_DIR' Expected")
         .into();
 
-    let libbcachefs_inc_dir = std::path::Path::new("../..");
+    let libbcachefs_inc_dir = std::path::Path::new("../c_src");
 
-    let _libbcachefs_dir = top_dir.join("libbcachefs").join("libbcachefs");
     let bindings = bindgen::builder()
         .header(
             top_dir
diff --git a/rust-src/bch_bindgen/rustfmt.toml b/bch_bindgen/rustfmt.toml
similarity index 100%
rename from rust-src/bch_bindgen/rustfmt.toml
rename to bch_bindgen/rustfmt.toml
diff --git a/rust-src/bch_bindgen/src/bcachefs.rs b/bch_bindgen/src/bcachefs.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/bcachefs.rs
rename to bch_bindgen/src/bcachefs.rs
diff --git a/rust-src/bch_bindgen/src/bkey.rs b/bch_bindgen/src/bkey.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/bkey.rs
rename to bch_bindgen/src/bkey.rs
diff --git a/rust-src/bch_bindgen/src/btree.rs b/bch_bindgen/src/btree.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/btree.rs
rename to bch_bindgen/src/btree.rs
diff --git a/rust-src/bch_bindgen/src/errcode.rs b/bch_bindgen/src/errcode.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/errcode.rs
rename to bch_bindgen/src/errcode.rs
diff --git a/rust-src/bch_bindgen/src/fs.rs b/bch_bindgen/src/fs.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/fs.rs
rename to bch_bindgen/src/fs.rs
diff --git a/rust-src/bch_bindgen/src/keyutils.rs b/bch_bindgen/src/keyutils.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/keyutils.rs
rename to bch_bindgen/src/keyutils.rs
diff --git a/rust-src/bch_bindgen/src/keyutils_wrapper.h b/bch_bindgen/src/keyutils_wrapper.h
similarity index 100%
rename from rust-src/bch_bindgen/src/keyutils_wrapper.h
rename to bch_bindgen/src/keyutils_wrapper.h
diff --git a/rust-src/bch_bindgen/src/lib.rs b/bch_bindgen/src/lib.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/lib.rs
rename to bch_bindgen/src/lib.rs
diff --git a/bch_bindgen/src/libbcachefs_wrapper.h b/bch_bindgen/src/libbcachefs_wrapper.h
new file mode 100644
index 0000000..141b083
--- /dev/null
+++ b/bch_bindgen/src/libbcachefs_wrapper.h
@@ -0,0 +1,22 @@
+#include "libbcachefs/super-io.h"
+#include "libbcachefs/checksum.h"
+#include "libbcachefs/bcachefs_format.h"
+#include "libbcachefs/btree_cache.h"
+#include "libbcachefs/btree_iter.h"
+#include "libbcachefs/debug.h"
+#include "libbcachefs/errcode.h"
+#include "libbcachefs/error.h"
+#include "libbcachefs/opts.h"
+#include "libbcachefs.h"
+#include "crypto.h"
+#include "include/linux/bio.h"
+#include "include/linux/blkdev.h"
+#include "cmds.h"
+#include "raid/raid.h"
+
+
+#define MARK_FIX_753(req_name) const blk_mode_t Fix753_##req_name = req_name;
+
+MARK_FIX_753(BLK_OPEN_READ);
+MARK_FIX_753(BLK_OPEN_WRITE);
+MARK_FIX_753(BLK_OPEN_EXCL);
diff --git a/rust-src/bch_bindgen/src/opts.rs b/bch_bindgen/src/opts.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/opts.rs
rename to bch_bindgen/src/opts.rs
diff --git a/rust-src/bch_bindgen/src/rs.rs b/bch_bindgen/src/rs.rs
similarity index 100%
rename from rust-src/bch_bindgen/src/rs.rs
rename to bch_bindgen/src/rs.rs
diff --git a/build.nix b/build.nix
index 831c7e9..a37a6c6 100644
--- a/build.nix
+++ b/build.nix
@@ -35,12 +35,12 @@ in stdenv.mkDerivation {
 
   BCACHEFS_FUSE = if fuseSupport then "1" else "";
 
-  cargoRoot = "rust-src";
+  cargoRoot = ".";
   # when git-based crates are updated, run:
   # nix run github:Mic92/nix-update -- --version=skip --flake default
   # to update the hashes
   cargoDeps = rustPlatform.importCargoLock {
-    lockFile = "${src}/rust-src/Cargo.lock";
+    lockFile = "${src}/Cargo.lock";
     outputHashes = {
       "bindgen-0.64.0" = "sha256-GNG8as33HLRYJGYe0nw6qBzq86aHiGonyynEM7gaEE4=";
     };
diff --git a/rust-src/build.rs b/build.rs
similarity index 86%
rename from rust-src/build.rs
rename to build.rs
index e4662bd..3364c6a 100644
--- a/rust-src/build.rs
+++ b/build.rs
@@ -1,6 +1,6 @@
 fn main() {
-    println!("cargo:rustc-link-search=..");
-    println!("cargo:rerun-if-changed=../libbcachefs.a");
+    println!("cargo:rustc-link-search=c_src");
+    println!("cargo:rerun-if-changed=c_src/libbcachefs.a");
     println!("cargo:rustc-link-lib=static:+whole-archive=bcachefs");
 
     println!("cargo:rustc-link-lib=urcu");
diff --git a/bcachefs.c b/c_src/bcachefs.c
similarity index 100%
rename from bcachefs.c
rename to c_src/bcachefs.c
diff --git a/ccan/array_size/LICENSE b/c_src/ccan/array_size/LICENSE
similarity index 100%
rename from ccan/array_size/LICENSE
rename to c_src/ccan/array_size/LICENSE
diff --git a/ccan/array_size/_info b/c_src/ccan/array_size/_info
similarity index 100%
rename from ccan/array_size/_info
rename to c_src/ccan/array_size/_info
diff --git a/ccan/array_size/array_size.h b/c_src/ccan/array_size/array_size.h
similarity index 100%
rename from ccan/array_size/array_size.h
rename to c_src/ccan/array_size/array_size.h
diff --git a/ccan/build_assert/LICENSE b/c_src/ccan/build_assert/LICENSE
similarity index 100%
rename from ccan/build_assert/LICENSE
rename to c_src/ccan/build_assert/LICENSE
diff --git a/ccan/build_assert/_info b/c_src/ccan/build_assert/_info
similarity index 100%
rename from ccan/build_assert/_info
rename to c_src/ccan/build_assert/_info
diff --git a/ccan/build_assert/build_assert.h b/c_src/ccan/build_assert/build_assert.h
similarity index 100%
rename from ccan/build_assert/build_assert.h
rename to c_src/ccan/build_assert/build_assert.h
diff --git a/ccan/compiler/LICENSE b/c_src/ccan/compiler/LICENSE
similarity index 100%
rename from ccan/compiler/LICENSE
rename to c_src/ccan/compiler/LICENSE
diff --git a/ccan/compiler/_info b/c_src/ccan/compiler/_info
similarity index 100%
rename from ccan/compiler/_info
rename to c_src/ccan/compiler/_info
diff --git a/ccan/compiler/compiler.h b/c_src/ccan/compiler/compiler.h
similarity index 100%
rename from ccan/compiler/compiler.h
rename to c_src/ccan/compiler/compiler.h
diff --git a/cmd_assemble.c b/c_src/cmd_assemble.c
similarity index 100%
rename from cmd_assemble.c
rename to c_src/cmd_assemble.c
diff --git a/cmd_attr.c b/c_src/cmd_attr.c
similarity index 100%
rename from cmd_attr.c
rename to c_src/cmd_attr.c
diff --git a/cmd_counters.c b/c_src/cmd_counters.c
similarity index 100%
rename from cmd_counters.c
rename to c_src/cmd_counters.c
diff --git a/cmd_data.c b/c_src/cmd_data.c
similarity index 100%
rename from cmd_data.c
rename to c_src/cmd_data.c
diff --git a/cmd_device.c b/c_src/cmd_device.c
similarity index 100%
rename from cmd_device.c
rename to c_src/cmd_device.c
diff --git a/cmd_dump.c b/c_src/cmd_dump.c
similarity index 100%
rename from cmd_dump.c
rename to c_src/cmd_dump.c
diff --git a/cmd_format.c b/c_src/cmd_format.c
similarity index 100%
rename from cmd_format.c
rename to c_src/cmd_format.c
diff --git a/cmd_fs.c b/c_src/cmd_fs.c
similarity index 100%
rename from cmd_fs.c
rename to c_src/cmd_fs.c
diff --git a/cmd_fsck.c b/c_src/cmd_fsck.c
similarity index 100%
rename from cmd_fsck.c
rename to c_src/cmd_fsck.c
diff --git a/cmd_fusemount.c b/c_src/cmd_fusemount.c
similarity index 100%
rename from cmd_fusemount.c
rename to c_src/cmd_fusemount.c
diff --git a/cmd_key.c b/c_src/cmd_key.c
similarity index 100%
rename from cmd_key.c
rename to c_src/cmd_key.c
diff --git a/cmd_kill_btree_node.c b/c_src/cmd_kill_btree_node.c
similarity index 100%
rename from cmd_kill_btree_node.c
rename to c_src/cmd_kill_btree_node.c
diff --git a/cmd_list_journal.c b/c_src/cmd_list_journal.c
similarity index 100%
rename from cmd_list_journal.c
rename to c_src/cmd_list_journal.c
diff --git a/cmd_migrate.c b/c_src/cmd_migrate.c
similarity index 100%
rename from cmd_migrate.c
rename to c_src/cmd_migrate.c
diff --git a/cmd_option.c b/c_src/cmd_option.c
similarity index 100%
rename from cmd_option.c
rename to c_src/cmd_option.c
diff --git a/cmd_run.c b/c_src/cmd_run.c
similarity index 100%
rename from cmd_run.c
rename to c_src/cmd_run.c
diff --git a/cmd_subvolume.c b/c_src/cmd_subvolume.c
similarity index 100%
rename from cmd_subvolume.c
rename to c_src/cmd_subvolume.c
diff --git a/cmd_version.c b/c_src/cmd_version.c
similarity index 100%
rename from cmd_version.c
rename to c_src/cmd_version.c
diff --git a/cmds.h b/c_src/cmds.h
similarity index 100%
rename from cmds.h
rename to c_src/cmds.h
diff --git a/config.h b/c_src/config.h
similarity index 100%
rename from config.h
rename to c_src/config.h
diff --git a/crypto.c b/c_src/crypto.c
similarity index 100%
rename from crypto.c
rename to c_src/crypto.c
diff --git a/crypto.h b/c_src/crypto.h
similarity index 100%
rename from crypto.h
rename to c_src/crypto.h
diff --git a/include/asm/page.h b/c_src/include/asm/page.h
similarity index 100%
rename from include/asm/page.h
rename to c_src/include/asm/page.h
diff --git a/include/asm/unaligned.h b/c_src/include/asm/unaligned.h
similarity index 100%
rename from include/asm/unaligned.h
rename to c_src/include/asm/unaligned.h
diff --git a/include/crypto/algapi.h b/c_src/include/crypto/algapi.h
similarity index 100%
rename from include/crypto/algapi.h
rename to c_src/include/crypto/algapi.h
diff --git a/include/crypto/chacha.h b/c_src/include/crypto/chacha.h
similarity index 100%
rename from include/crypto/chacha.h
rename to c_src/include/crypto/chacha.h
diff --git a/include/crypto/hash.h b/c_src/include/crypto/hash.h
similarity index 100%
rename from include/crypto/hash.h
rename to c_src/include/crypto/hash.h
diff --git a/include/crypto/poly1305.h b/c_src/include/crypto/poly1305.h
similarity index 100%
rename from include/crypto/poly1305.h
rename to c_src/include/crypto/poly1305.h
diff --git a/include/crypto/sha2.h b/c_src/include/crypto/sha2.h
similarity index 100%
rename from include/crypto/sha2.h
rename to c_src/include/crypto/sha2.h
diff --git a/include/crypto/skcipher.h b/c_src/include/crypto/skcipher.h
similarity index 100%
rename from include/crypto/skcipher.h
rename to c_src/include/crypto/skcipher.h
diff --git a/include/keys/user-type.h b/c_src/include/keys/user-type.h
similarity index 100%
rename from include/keys/user-type.h
rename to c_src/include/keys/user-type.h
diff --git a/include/linux/atomic.h b/c_src/include/linux/atomic.h
similarity index 100%
rename from include/linux/atomic.h
rename to c_src/include/linux/atomic.h
diff --git a/include/linux/backing-dev-defs.h b/c_src/include/linux/backing-dev-defs.h
similarity index 100%
rename from include/linux/backing-dev-defs.h
rename to c_src/include/linux/backing-dev-defs.h
diff --git a/include/linux/backing-dev.h b/c_src/include/linux/backing-dev.h
similarity index 100%
rename from include/linux/backing-dev.h
rename to c_src/include/linux/backing-dev.h
diff --git a/include/linux/bio.h b/c_src/include/linux/bio.h
similarity index 100%
rename from include/linux/bio.h
rename to c_src/include/linux/bio.h
diff --git a/include/linux/bit_spinlock.h b/c_src/include/linux/bit_spinlock.h
similarity index 100%
rename from include/linux/bit_spinlock.h
rename to c_src/include/linux/bit_spinlock.h
diff --git a/include/linux/bitmap.h b/c_src/include/linux/bitmap.h
similarity index 100%
rename from include/linux/bitmap.h
rename to c_src/include/linux/bitmap.h
diff --git a/include/linux/bitops.h b/c_src/include/linux/bitops.h
similarity index 100%
rename from include/linux/bitops.h
rename to c_src/include/linux/bitops.h
diff --git a/include/linux/blk_types.h b/c_src/include/linux/blk_types.h
similarity index 100%
rename from include/linux/blk_types.h
rename to c_src/include/linux/blk_types.h
diff --git a/include/linux/blkdev.h b/c_src/include/linux/blkdev.h
similarity index 100%
rename from include/linux/blkdev.h
rename to c_src/include/linux/blkdev.h
diff --git a/include/linux/bsearch.h b/c_src/include/linux/bsearch.h
similarity index 100%
rename from include/linux/bsearch.h
rename to c_src/include/linux/bsearch.h
diff --git a/include/linux/bug.h b/c_src/include/linux/bug.h
similarity index 100%
rename from include/linux/bug.h
rename to c_src/include/linux/bug.h
diff --git a/include/linux/bvec.h b/c_src/include/linux/bvec.h
similarity index 100%
rename from include/linux/bvec.h
rename to c_src/include/linux/bvec.h
diff --git a/include/linux/byteorder.h b/c_src/include/linux/byteorder.h
similarity index 100%
rename from include/linux/byteorder.h
rename to c_src/include/linux/byteorder.h
diff --git a/include/linux/cache.h b/c_src/include/linux/cache.h
similarity index 100%
rename from include/linux/cache.h
rename to c_src/include/linux/cache.h
diff --git a/include/linux/closure.h b/c_src/include/linux/closure.h
similarity index 100%
rename from include/linux/closure.h
rename to c_src/include/linux/closure.h
diff --git a/include/linux/compiler.h b/c_src/include/linux/compiler.h
similarity index 100%
rename from include/linux/compiler.h
rename to c_src/include/linux/compiler.h
diff --git a/include/linux/completion.h b/c_src/include/linux/completion.h
similarity index 100%
rename from include/linux/completion.h
rename to c_src/include/linux/completion.h
diff --git a/include/linux/console.h b/c_src/include/linux/console.h
similarity index 100%
rename from include/linux/console.h
rename to c_src/include/linux/console.h
diff --git a/include/linux/cpumask.h b/c_src/include/linux/cpumask.h
similarity index 100%
rename from include/linux/cpumask.h
rename to c_src/include/linux/cpumask.h
diff --git a/include/linux/crc32c.h b/c_src/include/linux/crc32c.h
similarity index 100%
rename from include/linux/crc32c.h
rename to c_src/include/linux/crc32c.h
diff --git a/include/linux/crc64.h b/c_src/include/linux/crc64.h
similarity index 100%
rename from include/linux/crc64.h
rename to c_src/include/linux/crc64.h
diff --git a/include/linux/crypto.h b/c_src/include/linux/crypto.h
similarity index 100%
rename from include/linux/crypto.h
rename to c_src/include/linux/crypto.h
diff --git a/include/linux/ctype.h b/c_src/include/linux/ctype.h
similarity index 100%
rename from include/linux/ctype.h
rename to c_src/include/linux/ctype.h
diff --git a/include/linux/dcache.h b/c_src/include/linux/dcache.h
similarity index 100%
rename from include/linux/dcache.h
rename to c_src/include/linux/dcache.h
diff --git a/include/linux/debugfs.h b/c_src/include/linux/debugfs.h
similarity index 100%
rename from include/linux/debugfs.h
rename to c_src/include/linux/debugfs.h
diff --git a/include/linux/device.h b/c_src/include/linux/device.h
similarity index 100%
rename from include/linux/device.h
rename to c_src/include/linux/device.h
diff --git a/include/linux/dynamic_fault.h b/c_src/include/linux/dynamic_fault.h
similarity index 100%
rename from include/linux/dynamic_fault.h
rename to c_src/include/linux/dynamic_fault.h
diff --git a/include/linux/err.h b/c_src/include/linux/err.h
similarity index 100%
rename from include/linux/err.h
rename to c_src/include/linux/err.h
diff --git a/include/linux/errname.h b/c_src/include/linux/errname.h
similarity index 100%
rename from include/linux/errname.h
rename to c_src/include/linux/errname.h
diff --git a/include/linux/export.h b/c_src/include/linux/export.h
similarity index 100%
rename from include/linux/export.h
rename to c_src/include/linux/export.h
diff --git a/include/linux/freezer.h b/c_src/include/linux/freezer.h
similarity index 100%
rename from include/linux/freezer.h
rename to c_src/include/linux/freezer.h
diff --git a/include/linux/generic-radix-tree.h b/c_src/include/linux/generic-radix-tree.h
similarity index 100%
rename from include/linux/generic-radix-tree.h
rename to c_src/include/linux/generic-radix-tree.h
diff --git a/include/linux/genhd.h b/c_src/include/linux/genhd.h
similarity index 100%
rename from include/linux/genhd.h
rename to c_src/include/linux/genhd.h
diff --git a/include/linux/gfp.h b/c_src/include/linux/gfp.h
similarity index 100%
rename from include/linux/gfp.h
rename to c_src/include/linux/gfp.h
diff --git a/include/linux/hash.h b/c_src/include/linux/hash.h
similarity index 100%
rename from include/linux/hash.h
rename to c_src/include/linux/hash.h
diff --git a/include/linux/idr.h b/c_src/include/linux/idr.h
similarity index 100%
rename from include/linux/idr.h
rename to c_src/include/linux/idr.h
diff --git a/include/linux/ioprio.h b/c_src/include/linux/ioprio.h
similarity index 100%
rename from include/linux/ioprio.h
rename to c_src/include/linux/ioprio.h
diff --git a/include/linux/jhash.h b/c_src/include/linux/jhash.h
similarity index 100%
rename from include/linux/jhash.h
rename to c_src/include/linux/jhash.h
diff --git a/include/linux/jiffies.h b/c_src/include/linux/jiffies.h
similarity index 100%
rename from include/linux/jiffies.h
rename to c_src/include/linux/jiffies.h
diff --git a/include/linux/kernel.h b/c_src/include/linux/kernel.h
similarity index 100%
rename from include/linux/kernel.h
rename to c_src/include/linux/kernel.h
diff --git a/include/linux/key.h b/c_src/include/linux/key.h
similarity index 100%
rename from include/linux/key.h
rename to c_src/include/linux/key.h
diff --git a/include/linux/kmemleak.h b/c_src/include/linux/kmemleak.h
similarity index 100%
rename from include/linux/kmemleak.h
rename to c_src/include/linux/kmemleak.h
diff --git a/include/linux/kobject.h b/c_src/include/linux/kobject.h
similarity index 100%
rename from include/linux/kobject.h
rename to c_src/include/linux/kobject.h
diff --git a/include/linux/kthread.h b/c_src/include/linux/kthread.h
similarity index 100%
rename from include/linux/kthread.h
rename to c_src/include/linux/kthread.h
diff --git a/include/linux/list.h b/c_src/include/linux/list.h
similarity index 100%
rename from include/linux/list.h
rename to c_src/include/linux/list.h
diff --git a/include/linux/list_nulls.h b/c_src/include/linux/list_nulls.h
similarity index 100%
rename from include/linux/list_nulls.h
rename to c_src/include/linux/list_nulls.h
diff --git a/include/linux/llist.h b/c_src/include/linux/llist.h
similarity index 100%
rename from include/linux/llist.h
rename to c_src/include/linux/llist.h
diff --git a/include/linux/lockdep.h b/c_src/include/linux/lockdep.h
similarity index 100%
rename from include/linux/lockdep.h
rename to c_src/include/linux/lockdep.h
diff --git a/include/linux/log2.h b/c_src/include/linux/log2.h
similarity index 100%
rename from include/linux/log2.h
rename to c_src/include/linux/log2.h
diff --git a/include/linux/lz4.h b/c_src/include/linux/lz4.h
similarity index 100%
rename from include/linux/lz4.h
rename to c_src/include/linux/lz4.h
diff --git a/include/linux/math.h b/c_src/include/linux/math.h
similarity index 100%
rename from include/linux/math.h
rename to c_src/include/linux/math.h
diff --git a/include/linux/math64.h b/c_src/include/linux/math64.h
similarity index 100%
rename from include/linux/math64.h
rename to c_src/include/linux/math64.h
diff --git a/include/linux/mempool.h b/c_src/include/linux/mempool.h
similarity index 100%
rename from include/linux/mempool.h
rename to c_src/include/linux/mempool.h
diff --git a/include/linux/minmax.h b/c_src/include/linux/minmax.h
similarity index 100%
rename from include/linux/minmax.h
rename to c_src/include/linux/minmax.h
diff --git a/include/linux/mm.h b/c_src/include/linux/mm.h
similarity index 100%
rename from include/linux/mm.h
rename to c_src/include/linux/mm.h
diff --git a/include/linux/module.h b/c_src/include/linux/module.h
similarity index 100%
rename from include/linux/module.h
rename to c_src/include/linux/module.h
diff --git a/include/linux/mutex.h b/c_src/include/linux/mutex.h
similarity index 100%
rename from include/linux/mutex.h
rename to c_src/include/linux/mutex.h
diff --git a/include/linux/osq_lock.h b/c_src/include/linux/osq_lock.h
similarity index 100%
rename from include/linux/osq_lock.h
rename to c_src/include/linux/osq_lock.h
diff --git a/include/linux/overflow.h b/c_src/include/linux/overflow.h
similarity index 100%
rename from include/linux/overflow.h
rename to c_src/include/linux/overflow.h
diff --git a/include/linux/page.h b/c_src/include/linux/page.h
similarity index 100%
rename from include/linux/page.h
rename to c_src/include/linux/page.h
diff --git a/include/linux/percpu-refcount.h b/c_src/include/linux/percpu-refcount.h
similarity index 100%
rename from include/linux/percpu-refcount.h
rename to c_src/include/linux/percpu-refcount.h
diff --git a/include/linux/percpu-rwsem.h b/c_src/include/linux/percpu-rwsem.h
similarity index 100%
rename from include/linux/percpu-rwsem.h
rename to c_src/include/linux/percpu-rwsem.h
diff --git a/include/linux/percpu.h b/c_src/include/linux/percpu.h
similarity index 100%
rename from include/linux/percpu.h
rename to c_src/include/linux/percpu.h
diff --git a/include/linux/poison.h b/c_src/include/linux/poison.h
similarity index 100%
rename from include/linux/poison.h
rename to c_src/include/linux/poison.h
diff --git a/include/linux/posix_acl.h b/c_src/include/linux/posix_acl.h
similarity index 100%
rename from include/linux/posix_acl.h
rename to c_src/include/linux/posix_acl.h
diff --git a/include/linux/posix_acl_xattr.h b/c_src/include/linux/posix_acl_xattr.h
similarity index 100%
rename from include/linux/posix_acl_xattr.h
rename to c_src/include/linux/posix_acl_xattr.h
diff --git a/include/linux/prandom.h b/c_src/include/linux/prandom.h
similarity index 100%
rename from include/linux/prandom.h
rename to c_src/include/linux/prandom.h
diff --git a/include/linux/preempt.h b/c_src/include/linux/preempt.h
similarity index 100%
rename from include/linux/preempt.h
rename to c_src/include/linux/preempt.h
diff --git a/include/linux/prefetch.h b/c_src/include/linux/prefetch.h
similarity index 100%
rename from include/linux/prefetch.h
rename to c_src/include/linux/prefetch.h
diff --git a/include/linux/pretty-printers.h b/c_src/include/linux/pretty-printers.h
similarity index 100%
rename from include/linux/pretty-printers.h
rename to c_src/include/linux/pretty-printers.h
diff --git a/include/linux/printk.h b/c_src/include/linux/printk.h
similarity index 100%
rename from include/linux/printk.h
rename to c_src/include/linux/printk.h
diff --git a/include/linux/random.h b/c_src/include/linux/random.h
similarity index 100%
rename from include/linux/random.h
rename to c_src/include/linux/random.h
diff --git a/include/linux/ratelimit.h b/c_src/include/linux/ratelimit.h
similarity index 100%
rename from include/linux/ratelimit.h
rename to c_src/include/linux/ratelimit.h
diff --git a/include/linux/rculist.h b/c_src/include/linux/rculist.h
similarity index 100%
rename from include/linux/rculist.h
rename to c_src/include/linux/rculist.h
diff --git a/include/linux/rcupdate.h b/c_src/include/linux/rcupdate.h
similarity index 100%
rename from include/linux/rcupdate.h
rename to c_src/include/linux/rcupdate.h
diff --git a/include/linux/refcount.h b/c_src/include/linux/refcount.h
similarity index 100%
rename from include/linux/refcount.h
rename to c_src/include/linux/refcount.h
diff --git a/include/linux/rhashtable-types.h b/c_src/include/linux/rhashtable-types.h
similarity index 100%
rename from include/linux/rhashtable-types.h
rename to c_src/include/linux/rhashtable-types.h
diff --git a/include/linux/rhashtable.h b/c_src/include/linux/rhashtable.h
similarity index 100%
rename from include/linux/rhashtable.h
rename to c_src/include/linux/rhashtable.h
diff --git a/include/linux/rwsem.h b/c_src/include/linux/rwsem.h
similarity index 100%
rename from include/linux/rwsem.h
rename to c_src/include/linux/rwsem.h
diff --git a/include/linux/scatterlist.h b/c_src/include/linux/scatterlist.h
similarity index 100%
rename from include/linux/scatterlist.h
rename to c_src/include/linux/scatterlist.h
diff --git a/include/linux/sched.h b/c_src/include/linux/sched.h
similarity index 100%
rename from include/linux/sched.h
rename to c_src/include/linux/sched.h
diff --git a/include/linux/sched/clock.h b/c_src/include/linux/sched/clock.h
similarity index 100%
rename from include/linux/sched/clock.h
rename to c_src/include/linux/sched/clock.h
diff --git a/include/linux/sched/cputime.h b/c_src/include/linux/sched/cputime.h
similarity index 100%
rename from include/linux/sched/cputime.h
rename to c_src/include/linux/sched/cputime.h
diff --git a/include/linux/sched/debug.h b/c_src/include/linux/sched/debug.h
similarity index 100%
rename from include/linux/sched/debug.h
rename to c_src/include/linux/sched/debug.h
diff --git a/include/linux/sched/mm.h b/c_src/include/linux/sched/mm.h
similarity index 100%
rename from include/linux/sched/mm.h
rename to c_src/include/linux/sched/mm.h
diff --git a/include/linux/sched/rt.h b/c_src/include/linux/sched/rt.h
similarity index 100%
rename from include/linux/sched/rt.h
rename to c_src/include/linux/sched/rt.h
diff --git a/include/linux/sched/signal.h b/c_src/include/linux/sched/signal.h
similarity index 100%
rename from include/linux/sched/signal.h
rename to c_src/include/linux/sched/signal.h
diff --git a/include/linux/sched/task.h b/c_src/include/linux/sched/task.h
similarity index 100%
rename from include/linux/sched/task.h
rename to c_src/include/linux/sched/task.h
diff --git a/include/linux/sched/task_stack.h b/c_src/include/linux/sched/task_stack.h
similarity index 100%
rename from include/linux/sched/task_stack.h
rename to c_src/include/linux/sched/task_stack.h
diff --git a/include/linux/semaphore.h b/c_src/include/linux/semaphore.h
similarity index 100%
rename from include/linux/semaphore.h
rename to c_src/include/linux/semaphore.h
diff --git a/include/linux/seq_buf.h b/c_src/include/linux/seq_buf.h
similarity index 100%
rename from include/linux/seq_buf.h
rename to c_src/include/linux/seq_buf.h
diff --git a/include/linux/seq_file.h b/c_src/include/linux/seq_file.h
similarity index 100%
rename from include/linux/seq_file.h
rename to c_src/include/linux/seq_file.h
diff --git a/include/linux/seqlock.h b/c_src/include/linux/seqlock.h
similarity index 100%
rename from include/linux/seqlock.h
rename to c_src/include/linux/seqlock.h
diff --git a/include/linux/shrinker.h b/c_src/include/linux/shrinker.h
similarity index 100%
rename from include/linux/shrinker.h
rename to c_src/include/linux/shrinker.h
diff --git a/include/linux/siphash.h b/c_src/include/linux/siphash.h
similarity index 100%
rename from include/linux/siphash.h
rename to c_src/include/linux/siphash.h
diff --git a/include/linux/slab.h b/c_src/include/linux/slab.h
similarity index 100%
rename from include/linux/slab.h
rename to c_src/include/linux/slab.h
diff --git a/include/linux/sort.h b/c_src/include/linux/sort.h
similarity index 100%
rename from include/linux/sort.h
rename to c_src/include/linux/sort.h
diff --git a/include/linux/spinlock.h b/c_src/include/linux/spinlock.h
similarity index 100%
rename from include/linux/spinlock.h
rename to c_src/include/linux/spinlock.h
diff --git a/include/linux/srcu.h b/c_src/include/linux/srcu.h
similarity index 100%
rename from include/linux/srcu.h
rename to c_src/include/linux/srcu.h
diff --git a/include/linux/stat.h b/c_src/include/linux/stat.h
similarity index 100%
rename from include/linux/stat.h
rename to c_src/include/linux/stat.h
diff --git a/include/linux/string.h b/c_src/include/linux/string.h
similarity index 100%
rename from include/linux/string.h
rename to c_src/include/linux/string.h
diff --git a/include/linux/string_helpers.h b/c_src/include/linux/string_helpers.h
similarity index 100%
rename from include/linux/string_helpers.h
rename to c_src/include/linux/string_helpers.h
diff --git a/include/linux/sysfs.h b/c_src/include/linux/sysfs.h
similarity index 100%
rename from include/linux/sysfs.h
rename to c_src/include/linux/sysfs.h
diff --git a/include/linux/time64.h b/c_src/include/linux/time64.h
similarity index 100%
rename from include/linux/time64.h
rename to c_src/include/linux/time64.h
diff --git a/include/linux/timer.h b/c_src/include/linux/timer.h
similarity index 100%
rename from include/linux/timer.h
rename to c_src/include/linux/timer.h
diff --git a/include/linux/tracepoint.h b/c_src/include/linux/tracepoint.h
similarity index 100%
rename from include/linux/tracepoint.h
rename to c_src/include/linux/tracepoint.h
diff --git a/include/linux/typecheck.h b/c_src/include/linux/typecheck.h
similarity index 100%
rename from include/linux/typecheck.h
rename to c_src/include/linux/typecheck.h
diff --git a/include/linux/types.h b/c_src/include/linux/types.h
similarity index 100%
rename from include/linux/types.h
rename to c_src/include/linux/types.h
diff --git a/include/linux/unaligned/be_byteshift.h b/c_src/include/linux/unaligned/be_byteshift.h
similarity index 100%
rename from include/linux/unaligned/be_byteshift.h
rename to c_src/include/linux/unaligned/be_byteshift.h
diff --git a/include/linux/unaligned/be_struct.h b/c_src/include/linux/unaligned/be_struct.h
similarity index 100%
rename from include/linux/unaligned/be_struct.h
rename to c_src/include/linux/unaligned/be_struct.h
diff --git a/include/linux/unaligned/generic.h b/c_src/include/linux/unaligned/generic.h
similarity index 100%
rename from include/linux/unaligned/generic.h
rename to c_src/include/linux/unaligned/generic.h
diff --git a/include/linux/unaligned/le_byteshift.h b/c_src/include/linux/unaligned/le_byteshift.h
similarity index 100%
rename from include/linux/unaligned/le_byteshift.h
rename to c_src/include/linux/unaligned/le_byteshift.h
diff --git a/include/linux/unaligned/le_struct.h b/c_src/include/linux/unaligned/le_struct.h
similarity index 100%
rename from include/linux/unaligned/le_struct.h
rename to c_src/include/linux/unaligned/le_struct.h
diff --git a/include/linux/unaligned/packed_struct.h b/c_src/include/linux/unaligned/packed_struct.h
similarity index 100%
rename from include/linux/unaligned/packed_struct.h
rename to c_src/include/linux/unaligned/packed_struct.h
diff --git a/include/linux/uuid.h b/c_src/include/linux/uuid.h
similarity index 100%
rename from include/linux/uuid.h
rename to c_src/include/linux/uuid.h
diff --git a/include/linux/vmalloc.h b/c_src/include/linux/vmalloc.h
similarity index 100%
rename from include/linux/vmalloc.h
rename to c_src/include/linux/vmalloc.h
diff --git a/include/linux/wait.h b/c_src/include/linux/wait.h
similarity index 100%
rename from include/linux/wait.h
rename to c_src/include/linux/wait.h
diff --git a/include/linux/workqueue.h b/c_src/include/linux/workqueue.h
similarity index 100%
rename from include/linux/workqueue.h
rename to c_src/include/linux/workqueue.h
diff --git a/include/linux/xattr.h b/c_src/include/linux/xattr.h
similarity index 100%
rename from include/linux/xattr.h
rename to c_src/include/linux/xattr.h
diff --git a/include/linux/xxhash.h b/c_src/include/linux/xxhash.h
similarity index 100%
rename from include/linux/xxhash.h
rename to c_src/include/linux/xxhash.h
diff --git a/include/linux/zlib.h b/c_src/include/linux/zlib.h
similarity index 100%
rename from include/linux/zlib.h
rename to c_src/include/linux/zlib.h
diff --git a/include/linux/zstd.h b/c_src/include/linux/zstd.h
similarity index 100%
rename from include/linux/zstd.h
rename to c_src/include/linux/zstd.h
diff --git a/include/linux/zstd_errors.h b/c_src/include/linux/zstd_errors.h
similarity index 100%
rename from include/linux/zstd_errors.h
rename to c_src/include/linux/zstd_errors.h
diff --git a/include/trace/define_trace.h b/c_src/include/trace/define_trace.h
similarity index 100%
rename from include/trace/define_trace.h
rename to c_src/include/trace/define_trace.h
diff --git a/include/trace/events/lock.h b/c_src/include/trace/events/lock.h
similarity index 100%
rename from include/trace/events/lock.h
rename to c_src/include/trace/events/lock.h
diff --git a/include/uapi/linux/xattr.h b/c_src/include/uapi/linux/xattr.h
similarity index 100%
rename from include/uapi/linux/xattr.h
rename to c_src/include/uapi/linux/xattr.h
diff --git a/libbcachefs.c b/c_src/libbcachefs.c
similarity index 100%
rename from libbcachefs.c
rename to c_src/libbcachefs.c
diff --git a/libbcachefs.h b/c_src/libbcachefs.h
similarity index 100%
rename from libbcachefs.h
rename to c_src/libbcachefs.h
diff --git a/libbcachefs/acl.c b/c_src/libbcachefs/acl.c
similarity index 100%
rename from libbcachefs/acl.c
rename to c_src/libbcachefs/acl.c
diff --git a/libbcachefs/acl.h b/c_src/libbcachefs/acl.h
similarity index 100%
rename from libbcachefs/acl.h
rename to c_src/libbcachefs/acl.h
diff --git a/libbcachefs/alloc_background.c b/c_src/libbcachefs/alloc_background.c
similarity index 100%
rename from libbcachefs/alloc_background.c
rename to c_src/libbcachefs/alloc_background.c
diff --git a/libbcachefs/alloc_background.h b/c_src/libbcachefs/alloc_background.h
similarity index 100%
rename from libbcachefs/alloc_background.h
rename to c_src/libbcachefs/alloc_background.h
diff --git a/libbcachefs/alloc_foreground.c b/c_src/libbcachefs/alloc_foreground.c
similarity index 100%
rename from libbcachefs/alloc_foreground.c
rename to c_src/libbcachefs/alloc_foreground.c
diff --git a/libbcachefs/alloc_foreground.h b/c_src/libbcachefs/alloc_foreground.h
similarity index 100%
rename from libbcachefs/alloc_foreground.h
rename to c_src/libbcachefs/alloc_foreground.h
diff --git a/libbcachefs/alloc_types.h b/c_src/libbcachefs/alloc_types.h
similarity index 100%
rename from libbcachefs/alloc_types.h
rename to c_src/libbcachefs/alloc_types.h
diff --git a/libbcachefs/backpointers.c b/c_src/libbcachefs/backpointers.c
similarity index 100%
rename from libbcachefs/backpointers.c
rename to c_src/libbcachefs/backpointers.c
diff --git a/libbcachefs/backpointers.h b/c_src/libbcachefs/backpointers.h
similarity index 100%
rename from libbcachefs/backpointers.h
rename to c_src/libbcachefs/backpointers.h
diff --git a/libbcachefs/bbpos.h b/c_src/libbcachefs/bbpos.h
similarity index 100%
rename from libbcachefs/bbpos.h
rename to c_src/libbcachefs/bbpos.h
diff --git a/libbcachefs/bbpos_types.h b/c_src/libbcachefs/bbpos_types.h
similarity index 100%
rename from libbcachefs/bbpos_types.h
rename to c_src/libbcachefs/bbpos_types.h
diff --git a/libbcachefs/bcachefs.h b/c_src/libbcachefs/bcachefs.h
similarity index 100%
rename from libbcachefs/bcachefs.h
rename to c_src/libbcachefs/bcachefs.h
diff --git a/libbcachefs/bcachefs_format.h b/c_src/libbcachefs/bcachefs_format.h
similarity index 100%
rename from libbcachefs/bcachefs_format.h
rename to c_src/libbcachefs/bcachefs_format.h
diff --git a/libbcachefs/bcachefs_ioctl.h b/c_src/libbcachefs/bcachefs_ioctl.h
similarity index 100%
rename from libbcachefs/bcachefs_ioctl.h
rename to c_src/libbcachefs/bcachefs_ioctl.h
diff --git a/libbcachefs/bkey.c b/c_src/libbcachefs/bkey.c
similarity index 100%
rename from libbcachefs/bkey.c
rename to c_src/libbcachefs/bkey.c
diff --git a/libbcachefs/bkey.h b/c_src/libbcachefs/bkey.h
similarity index 100%
rename from libbcachefs/bkey.h
rename to c_src/libbcachefs/bkey.h
diff --git a/libbcachefs/bkey_buf.h b/c_src/libbcachefs/bkey_buf.h
similarity index 100%
rename from libbcachefs/bkey_buf.h
rename to c_src/libbcachefs/bkey_buf.h
diff --git a/libbcachefs/bkey_cmp.h b/c_src/libbcachefs/bkey_cmp.h
similarity index 100%
rename from libbcachefs/bkey_cmp.h
rename to c_src/libbcachefs/bkey_cmp.h
diff --git a/libbcachefs/bkey_methods.c b/c_src/libbcachefs/bkey_methods.c
similarity index 100%
rename from libbcachefs/bkey_methods.c
rename to c_src/libbcachefs/bkey_methods.c
diff --git a/libbcachefs/bkey_methods.h b/c_src/libbcachefs/bkey_methods.h
similarity index 100%
rename from libbcachefs/bkey_methods.h
rename to c_src/libbcachefs/bkey_methods.h
diff --git a/libbcachefs/bkey_sort.c b/c_src/libbcachefs/bkey_sort.c
similarity index 100%
rename from libbcachefs/bkey_sort.c
rename to c_src/libbcachefs/bkey_sort.c
diff --git a/libbcachefs/bkey_sort.h b/c_src/libbcachefs/bkey_sort.h
similarity index 100%
rename from libbcachefs/bkey_sort.h
rename to c_src/libbcachefs/bkey_sort.h
diff --git a/libbcachefs/bset.c b/c_src/libbcachefs/bset.c
similarity index 100%
rename from libbcachefs/bset.c
rename to c_src/libbcachefs/bset.c
diff --git a/libbcachefs/bset.h b/c_src/libbcachefs/bset.h
similarity index 100%
rename from libbcachefs/bset.h
rename to c_src/libbcachefs/bset.h
diff --git a/libbcachefs/btree_cache.c b/c_src/libbcachefs/btree_cache.c
similarity index 100%
rename from libbcachefs/btree_cache.c
rename to c_src/libbcachefs/btree_cache.c
diff --git a/libbcachefs/btree_cache.h b/c_src/libbcachefs/btree_cache.h
similarity index 100%
rename from libbcachefs/btree_cache.h
rename to c_src/libbcachefs/btree_cache.h
diff --git a/libbcachefs/btree_gc.c b/c_src/libbcachefs/btree_gc.c
similarity index 100%
rename from libbcachefs/btree_gc.c
rename to c_src/libbcachefs/btree_gc.c
diff --git a/libbcachefs/btree_gc.h b/c_src/libbcachefs/btree_gc.h
similarity index 100%
rename from libbcachefs/btree_gc.h
rename to c_src/libbcachefs/btree_gc.h
diff --git a/libbcachefs/btree_io.c b/c_src/libbcachefs/btree_io.c
similarity index 100%
rename from libbcachefs/btree_io.c
rename to c_src/libbcachefs/btree_io.c
diff --git a/libbcachefs/btree_io.h b/c_src/libbcachefs/btree_io.h
similarity index 100%
rename from libbcachefs/btree_io.h
rename to c_src/libbcachefs/btree_io.h
diff --git a/libbcachefs/btree_iter.c b/c_src/libbcachefs/btree_iter.c
similarity index 100%
rename from libbcachefs/btree_iter.c
rename to c_src/libbcachefs/btree_iter.c
diff --git a/libbcachefs/btree_iter.h b/c_src/libbcachefs/btree_iter.h
similarity index 100%
rename from libbcachefs/btree_iter.h
rename to c_src/libbcachefs/btree_iter.h
diff --git a/libbcachefs/btree_journal_iter.c b/c_src/libbcachefs/btree_journal_iter.c
similarity index 100%
rename from libbcachefs/btree_journal_iter.c
rename to c_src/libbcachefs/btree_journal_iter.c
diff --git a/libbcachefs/btree_journal_iter.h b/c_src/libbcachefs/btree_journal_iter.h
similarity index 100%
rename from libbcachefs/btree_journal_iter.h
rename to c_src/libbcachefs/btree_journal_iter.h
diff --git a/libbcachefs/btree_key_cache.c b/c_src/libbcachefs/btree_key_cache.c
similarity index 100%
rename from libbcachefs/btree_key_cache.c
rename to c_src/libbcachefs/btree_key_cache.c
diff --git a/libbcachefs/btree_key_cache.h b/c_src/libbcachefs/btree_key_cache.h
similarity index 100%
rename from libbcachefs/btree_key_cache.h
rename to c_src/libbcachefs/btree_key_cache.h
diff --git a/libbcachefs/btree_key_cache_types.h b/c_src/libbcachefs/btree_key_cache_types.h
similarity index 100%
rename from libbcachefs/btree_key_cache_types.h
rename to c_src/libbcachefs/btree_key_cache_types.h
diff --git a/libbcachefs/btree_locking.c b/c_src/libbcachefs/btree_locking.c
similarity index 100%
rename from libbcachefs/btree_locking.c
rename to c_src/libbcachefs/btree_locking.c
diff --git a/libbcachefs/btree_locking.h b/c_src/libbcachefs/btree_locking.h
similarity index 100%
rename from libbcachefs/btree_locking.h
rename to c_src/libbcachefs/btree_locking.h
diff --git a/libbcachefs/btree_trans_commit.c b/c_src/libbcachefs/btree_trans_commit.c
similarity index 100%
rename from libbcachefs/btree_trans_commit.c
rename to c_src/libbcachefs/btree_trans_commit.c
diff --git a/libbcachefs/btree_types.h b/c_src/libbcachefs/btree_types.h
similarity index 100%
rename from libbcachefs/btree_types.h
rename to c_src/libbcachefs/btree_types.h
diff --git a/libbcachefs/btree_update.c b/c_src/libbcachefs/btree_update.c
similarity index 100%
rename from libbcachefs/btree_update.c
rename to c_src/libbcachefs/btree_update.c
diff --git a/libbcachefs/btree_update.h b/c_src/libbcachefs/btree_update.h
similarity index 100%
rename from libbcachefs/btree_update.h
rename to c_src/libbcachefs/btree_update.h
diff --git a/libbcachefs/btree_update_interior.c b/c_src/libbcachefs/btree_update_interior.c
similarity index 100%
rename from libbcachefs/btree_update_interior.c
rename to c_src/libbcachefs/btree_update_interior.c
diff --git a/libbcachefs/btree_update_interior.h b/c_src/libbcachefs/btree_update_interior.h
similarity index 100%
rename from libbcachefs/btree_update_interior.h
rename to c_src/libbcachefs/btree_update_interior.h
diff --git a/libbcachefs/btree_write_buffer.c b/c_src/libbcachefs/btree_write_buffer.c
similarity index 100%
rename from libbcachefs/btree_write_buffer.c
rename to c_src/libbcachefs/btree_write_buffer.c
diff --git a/libbcachefs/btree_write_buffer.h b/c_src/libbcachefs/btree_write_buffer.h
similarity index 100%
rename from libbcachefs/btree_write_buffer.h
rename to c_src/libbcachefs/btree_write_buffer.h
diff --git a/libbcachefs/btree_write_buffer_types.h b/c_src/libbcachefs/btree_write_buffer_types.h
similarity index 100%
rename from libbcachefs/btree_write_buffer_types.h
rename to c_src/libbcachefs/btree_write_buffer_types.h
diff --git a/libbcachefs/buckets.c b/c_src/libbcachefs/buckets.c
similarity index 100%
rename from libbcachefs/buckets.c
rename to c_src/libbcachefs/buckets.c
diff --git a/libbcachefs/buckets.h b/c_src/libbcachefs/buckets.h
similarity index 100%
rename from libbcachefs/buckets.h
rename to c_src/libbcachefs/buckets.h
diff --git a/libbcachefs/buckets_types.h b/c_src/libbcachefs/buckets_types.h
similarity index 100%
rename from libbcachefs/buckets_types.h
rename to c_src/libbcachefs/buckets_types.h
diff --git a/libbcachefs/buckets_waiting_for_journal.c b/c_src/libbcachefs/buckets_waiting_for_journal.c
similarity index 100%
rename from libbcachefs/buckets_waiting_for_journal.c
rename to c_src/libbcachefs/buckets_waiting_for_journal.c
diff --git a/libbcachefs/buckets_waiting_for_journal.h b/c_src/libbcachefs/buckets_waiting_for_journal.h
similarity index 100%
rename from libbcachefs/buckets_waiting_for_journal.h
rename to c_src/libbcachefs/buckets_waiting_for_journal.h
diff --git a/libbcachefs/buckets_waiting_for_journal_types.h b/c_src/libbcachefs/buckets_waiting_for_journal_types.h
similarity index 100%
rename from libbcachefs/buckets_waiting_for_journal_types.h
rename to c_src/libbcachefs/buckets_waiting_for_journal_types.h
diff --git a/libbcachefs/chardev.c b/c_src/libbcachefs/chardev.c
similarity index 100%
rename from libbcachefs/chardev.c
rename to c_src/libbcachefs/chardev.c
diff --git a/libbcachefs/chardev.h b/c_src/libbcachefs/chardev.h
similarity index 100%
rename from libbcachefs/chardev.h
rename to c_src/libbcachefs/chardev.h
diff --git a/libbcachefs/checksum.c b/c_src/libbcachefs/checksum.c
similarity index 100%
rename from libbcachefs/checksum.c
rename to c_src/libbcachefs/checksum.c
diff --git a/libbcachefs/checksum.h b/c_src/libbcachefs/checksum.h
similarity index 100%
rename from libbcachefs/checksum.h
rename to c_src/libbcachefs/checksum.h
diff --git a/libbcachefs/clock.c b/c_src/libbcachefs/clock.c
similarity index 100%
rename from libbcachefs/clock.c
rename to c_src/libbcachefs/clock.c
diff --git a/libbcachefs/clock.h b/c_src/libbcachefs/clock.h
similarity index 100%
rename from libbcachefs/clock.h
rename to c_src/libbcachefs/clock.h
diff --git a/libbcachefs/clock_types.h b/c_src/libbcachefs/clock_types.h
similarity index 100%
rename from libbcachefs/clock_types.h
rename to c_src/libbcachefs/clock_types.h
diff --git a/libbcachefs/compress.c b/c_src/libbcachefs/compress.c
similarity index 100%
rename from libbcachefs/compress.c
rename to c_src/libbcachefs/compress.c
diff --git a/libbcachefs/compress.h b/c_src/libbcachefs/compress.h
similarity index 100%
rename from libbcachefs/compress.h
rename to c_src/libbcachefs/compress.h
diff --git a/libbcachefs/counters.c b/c_src/libbcachefs/counters.c
similarity index 100%
rename from libbcachefs/counters.c
rename to c_src/libbcachefs/counters.c
diff --git a/libbcachefs/counters.h b/c_src/libbcachefs/counters.h
similarity index 100%
rename from libbcachefs/counters.h
rename to c_src/libbcachefs/counters.h
diff --git a/libbcachefs/darray.c b/c_src/libbcachefs/darray.c
similarity index 100%
rename from libbcachefs/darray.c
rename to c_src/libbcachefs/darray.c
diff --git a/libbcachefs/darray.h b/c_src/libbcachefs/darray.h
similarity index 100%
rename from libbcachefs/darray.h
rename to c_src/libbcachefs/darray.h
diff --git a/libbcachefs/data_update.c b/c_src/libbcachefs/data_update.c
similarity index 100%
rename from libbcachefs/data_update.c
rename to c_src/libbcachefs/data_update.c
diff --git a/libbcachefs/data_update.h b/c_src/libbcachefs/data_update.h
similarity index 100%
rename from libbcachefs/data_update.h
rename to c_src/libbcachefs/data_update.h
diff --git a/libbcachefs/debug.c b/c_src/libbcachefs/debug.c
similarity index 100%
rename from libbcachefs/debug.c
rename to c_src/libbcachefs/debug.c
diff --git a/libbcachefs/debug.h b/c_src/libbcachefs/debug.h
similarity index 100%
rename from libbcachefs/debug.h
rename to c_src/libbcachefs/debug.h
diff --git a/libbcachefs/dirent.c b/c_src/libbcachefs/dirent.c
similarity index 100%
rename from libbcachefs/dirent.c
rename to c_src/libbcachefs/dirent.c
diff --git a/libbcachefs/dirent.h b/c_src/libbcachefs/dirent.h
similarity index 100%
rename from libbcachefs/dirent.h
rename to c_src/libbcachefs/dirent.h
diff --git a/libbcachefs/disk_groups.c b/c_src/libbcachefs/disk_groups.c
similarity index 100%
rename from libbcachefs/disk_groups.c
rename to c_src/libbcachefs/disk_groups.c
diff --git a/libbcachefs/disk_groups.h b/c_src/libbcachefs/disk_groups.h
similarity index 100%
rename from libbcachefs/disk_groups.h
rename to c_src/libbcachefs/disk_groups.h
diff --git a/libbcachefs/disk_groups_types.h b/c_src/libbcachefs/disk_groups_types.h
similarity index 100%
rename from libbcachefs/disk_groups_types.h
rename to c_src/libbcachefs/disk_groups_types.h
diff --git a/libbcachefs/ec.c b/c_src/libbcachefs/ec.c
similarity index 100%
rename from libbcachefs/ec.c
rename to c_src/libbcachefs/ec.c
diff --git a/libbcachefs/ec.h b/c_src/libbcachefs/ec.h
similarity index 100%
rename from libbcachefs/ec.h
rename to c_src/libbcachefs/ec.h
diff --git a/libbcachefs/ec_types.h b/c_src/libbcachefs/ec_types.h
similarity index 100%
rename from libbcachefs/ec_types.h
rename to c_src/libbcachefs/ec_types.h
diff --git a/libbcachefs/errcode.c b/c_src/libbcachefs/errcode.c
similarity index 100%
rename from libbcachefs/errcode.c
rename to c_src/libbcachefs/errcode.c
diff --git a/libbcachefs/errcode.h b/c_src/libbcachefs/errcode.h
similarity index 100%
rename from libbcachefs/errcode.h
rename to c_src/libbcachefs/errcode.h
diff --git a/libbcachefs/error.c b/c_src/libbcachefs/error.c
similarity index 100%
rename from libbcachefs/error.c
rename to c_src/libbcachefs/error.c
diff --git a/libbcachefs/error.h b/c_src/libbcachefs/error.h
similarity index 100%
rename from libbcachefs/error.h
rename to c_src/libbcachefs/error.h
diff --git a/libbcachefs/extent_update.c b/c_src/libbcachefs/extent_update.c
similarity index 100%
rename from libbcachefs/extent_update.c
rename to c_src/libbcachefs/extent_update.c
diff --git a/libbcachefs/extent_update.h b/c_src/libbcachefs/extent_update.h
similarity index 100%
rename from libbcachefs/extent_update.h
rename to c_src/libbcachefs/extent_update.h
diff --git a/libbcachefs/extents.c b/c_src/libbcachefs/extents.c
similarity index 100%
rename from libbcachefs/extents.c
rename to c_src/libbcachefs/extents.c
diff --git a/libbcachefs/extents.h b/c_src/libbcachefs/extents.h
similarity index 100%
rename from libbcachefs/extents.h
rename to c_src/libbcachefs/extents.h
diff --git a/libbcachefs/extents_types.h b/c_src/libbcachefs/extents_types.h
similarity index 100%
rename from libbcachefs/extents_types.h
rename to c_src/libbcachefs/extents_types.h
diff --git a/libbcachefs/eytzinger.h b/c_src/libbcachefs/eytzinger.h
similarity index 100%
rename from libbcachefs/eytzinger.h
rename to c_src/libbcachefs/eytzinger.h
diff --git a/libbcachefs/fifo.h b/c_src/libbcachefs/fifo.h
similarity index 100%
rename from libbcachefs/fifo.h
rename to c_src/libbcachefs/fifo.h
diff --git a/libbcachefs/fs-common.c b/c_src/libbcachefs/fs-common.c
similarity index 100%
rename from libbcachefs/fs-common.c
rename to c_src/libbcachefs/fs-common.c
diff --git a/libbcachefs/fs-common.h b/c_src/libbcachefs/fs-common.h
similarity index 100%
rename from libbcachefs/fs-common.h
rename to c_src/libbcachefs/fs-common.h
diff --git a/libbcachefs/fs-io-buffered.c b/c_src/libbcachefs/fs-io-buffered.c
similarity index 100%
rename from libbcachefs/fs-io-buffered.c
rename to c_src/libbcachefs/fs-io-buffered.c
diff --git a/libbcachefs/fs-io-buffered.h b/c_src/libbcachefs/fs-io-buffered.h
similarity index 100%
rename from libbcachefs/fs-io-buffered.h
rename to c_src/libbcachefs/fs-io-buffered.h
diff --git a/libbcachefs/fs-io-direct.c b/c_src/libbcachefs/fs-io-direct.c
similarity index 100%
rename from libbcachefs/fs-io-direct.c
rename to c_src/libbcachefs/fs-io-direct.c
diff --git a/libbcachefs/fs-io-direct.h b/c_src/libbcachefs/fs-io-direct.h
similarity index 100%
rename from libbcachefs/fs-io-direct.h
rename to c_src/libbcachefs/fs-io-direct.h
diff --git a/libbcachefs/fs-io-pagecache.c b/c_src/libbcachefs/fs-io-pagecache.c
similarity index 100%
rename from libbcachefs/fs-io-pagecache.c
rename to c_src/libbcachefs/fs-io-pagecache.c
diff --git a/libbcachefs/fs-io-pagecache.h b/c_src/libbcachefs/fs-io-pagecache.h
similarity index 100%
rename from libbcachefs/fs-io-pagecache.h
rename to c_src/libbcachefs/fs-io-pagecache.h
diff --git a/libbcachefs/fs-io.c b/c_src/libbcachefs/fs-io.c
similarity index 100%
rename from libbcachefs/fs-io.c
rename to c_src/libbcachefs/fs-io.c
diff --git a/libbcachefs/fs-io.h b/c_src/libbcachefs/fs-io.h
similarity index 100%
rename from libbcachefs/fs-io.h
rename to c_src/libbcachefs/fs-io.h
diff --git a/libbcachefs/fs-ioctl.c b/c_src/libbcachefs/fs-ioctl.c
similarity index 100%
rename from libbcachefs/fs-ioctl.c
rename to c_src/libbcachefs/fs-ioctl.c
diff --git a/libbcachefs/fs-ioctl.h b/c_src/libbcachefs/fs-ioctl.h
similarity index 100%
rename from libbcachefs/fs-ioctl.h
rename to c_src/libbcachefs/fs-ioctl.h
diff --git a/libbcachefs/fs.c b/c_src/libbcachefs/fs.c
similarity index 100%
rename from libbcachefs/fs.c
rename to c_src/libbcachefs/fs.c
diff --git a/libbcachefs/fs.h b/c_src/libbcachefs/fs.h
similarity index 100%
rename from libbcachefs/fs.h
rename to c_src/libbcachefs/fs.h
diff --git a/libbcachefs/fsck.c b/c_src/libbcachefs/fsck.c
similarity index 100%
rename from libbcachefs/fsck.c
rename to c_src/libbcachefs/fsck.c
diff --git a/libbcachefs/fsck.h b/c_src/libbcachefs/fsck.h
similarity index 100%
rename from libbcachefs/fsck.h
rename to c_src/libbcachefs/fsck.h
diff --git a/libbcachefs/inode.c b/c_src/libbcachefs/inode.c
similarity index 100%
rename from libbcachefs/inode.c
rename to c_src/libbcachefs/inode.c
diff --git a/libbcachefs/inode.h b/c_src/libbcachefs/inode.h
similarity index 100%
rename from libbcachefs/inode.h
rename to c_src/libbcachefs/inode.h
diff --git a/libbcachefs/io_misc.c b/c_src/libbcachefs/io_misc.c
similarity index 100%
rename from libbcachefs/io_misc.c
rename to c_src/libbcachefs/io_misc.c
diff --git a/libbcachefs/io_misc.h b/c_src/libbcachefs/io_misc.h
similarity index 100%
rename from libbcachefs/io_misc.h
rename to c_src/libbcachefs/io_misc.h
diff --git a/libbcachefs/io_read.c b/c_src/libbcachefs/io_read.c
similarity index 100%
rename from libbcachefs/io_read.c
rename to c_src/libbcachefs/io_read.c
diff --git a/libbcachefs/io_read.h b/c_src/libbcachefs/io_read.h
similarity index 100%
rename from libbcachefs/io_read.h
rename to c_src/libbcachefs/io_read.h
diff --git a/libbcachefs/io_write.c b/c_src/libbcachefs/io_write.c
similarity index 100%
rename from libbcachefs/io_write.c
rename to c_src/libbcachefs/io_write.c
diff --git a/libbcachefs/io_write.h b/c_src/libbcachefs/io_write.h
similarity index 100%
rename from libbcachefs/io_write.h
rename to c_src/libbcachefs/io_write.h
diff --git a/libbcachefs/io_write_types.h b/c_src/libbcachefs/io_write_types.h
similarity index 100%
rename from libbcachefs/io_write_types.h
rename to c_src/libbcachefs/io_write_types.h
diff --git a/libbcachefs/journal.c b/c_src/libbcachefs/journal.c
similarity index 100%
rename from libbcachefs/journal.c
rename to c_src/libbcachefs/journal.c
diff --git a/libbcachefs/journal.h b/c_src/libbcachefs/journal.h
similarity index 100%
rename from libbcachefs/journal.h
rename to c_src/libbcachefs/journal.h
diff --git a/libbcachefs/journal_io.c b/c_src/libbcachefs/journal_io.c
similarity index 100%
rename from libbcachefs/journal_io.c
rename to c_src/libbcachefs/journal_io.c
diff --git a/libbcachefs/journal_io.h b/c_src/libbcachefs/journal_io.h
similarity index 100%
rename from libbcachefs/journal_io.h
rename to c_src/libbcachefs/journal_io.h
diff --git a/libbcachefs/journal_reclaim.c b/c_src/libbcachefs/journal_reclaim.c
similarity index 100%
rename from libbcachefs/journal_reclaim.c
rename to c_src/libbcachefs/journal_reclaim.c
diff --git a/libbcachefs/journal_reclaim.h b/c_src/libbcachefs/journal_reclaim.h
similarity index 100%
rename from libbcachefs/journal_reclaim.h
rename to c_src/libbcachefs/journal_reclaim.h
diff --git a/libbcachefs/journal_sb.c b/c_src/libbcachefs/journal_sb.c
similarity index 100%
rename from libbcachefs/journal_sb.c
rename to c_src/libbcachefs/journal_sb.c
diff --git a/libbcachefs/journal_sb.h b/c_src/libbcachefs/journal_sb.h
similarity index 100%
rename from libbcachefs/journal_sb.h
rename to c_src/libbcachefs/journal_sb.h
diff --git a/libbcachefs/journal_seq_blacklist.c b/c_src/libbcachefs/journal_seq_blacklist.c
similarity index 100%
rename from libbcachefs/journal_seq_blacklist.c
rename to c_src/libbcachefs/journal_seq_blacklist.c
diff --git a/libbcachefs/journal_seq_blacklist.h b/c_src/libbcachefs/journal_seq_blacklist.h
similarity index 100%
rename from libbcachefs/journal_seq_blacklist.h
rename to c_src/libbcachefs/journal_seq_blacklist.h
diff --git a/libbcachefs/journal_types.h b/c_src/libbcachefs/journal_types.h
similarity index 100%
rename from libbcachefs/journal_types.h
rename to c_src/libbcachefs/journal_types.h
diff --git a/libbcachefs/keylist.c b/c_src/libbcachefs/keylist.c
similarity index 100%
rename from libbcachefs/keylist.c
rename to c_src/libbcachefs/keylist.c
diff --git a/libbcachefs/keylist.h b/c_src/libbcachefs/keylist.h
similarity index 100%
rename from libbcachefs/keylist.h
rename to c_src/libbcachefs/keylist.h
diff --git a/libbcachefs/keylist_types.h b/c_src/libbcachefs/keylist_types.h
similarity index 100%
rename from libbcachefs/keylist_types.h
rename to c_src/libbcachefs/keylist_types.h
diff --git a/libbcachefs/logged_ops.c b/c_src/libbcachefs/logged_ops.c
similarity index 100%
rename from libbcachefs/logged_ops.c
rename to c_src/libbcachefs/logged_ops.c
diff --git a/libbcachefs/logged_ops.h b/c_src/libbcachefs/logged_ops.h
similarity index 100%
rename from libbcachefs/logged_ops.h
rename to c_src/libbcachefs/logged_ops.h
diff --git a/libbcachefs/lru.c b/c_src/libbcachefs/lru.c
similarity index 100%
rename from libbcachefs/lru.c
rename to c_src/libbcachefs/lru.c
diff --git a/libbcachefs/lru.h b/c_src/libbcachefs/lru.h
similarity index 100%
rename from libbcachefs/lru.h
rename to c_src/libbcachefs/lru.h
diff --git a/libbcachefs/mean_and_variance.c b/c_src/libbcachefs/mean_and_variance.c
similarity index 100%
rename from libbcachefs/mean_and_variance.c
rename to c_src/libbcachefs/mean_and_variance.c
diff --git a/libbcachefs/mean_and_variance.h b/c_src/libbcachefs/mean_and_variance.h
similarity index 100%
rename from libbcachefs/mean_and_variance.h
rename to c_src/libbcachefs/mean_and_variance.h
diff --git a/libbcachefs/migrate.c b/c_src/libbcachefs/migrate.c
similarity index 100%
rename from libbcachefs/migrate.c
rename to c_src/libbcachefs/migrate.c
diff --git a/libbcachefs/migrate.h b/c_src/libbcachefs/migrate.h
similarity index 100%
rename from libbcachefs/migrate.h
rename to c_src/libbcachefs/migrate.h
diff --git a/libbcachefs/move.c b/c_src/libbcachefs/move.c
similarity index 100%
rename from libbcachefs/move.c
rename to c_src/libbcachefs/move.c
diff --git a/libbcachefs/move.h b/c_src/libbcachefs/move.h
similarity index 100%
rename from libbcachefs/move.h
rename to c_src/libbcachefs/move.h
diff --git a/libbcachefs/move_types.h b/c_src/libbcachefs/move_types.h
similarity index 100%
rename from libbcachefs/move_types.h
rename to c_src/libbcachefs/move_types.h
diff --git a/libbcachefs/movinggc.c b/c_src/libbcachefs/movinggc.c
similarity index 100%
rename from libbcachefs/movinggc.c
rename to c_src/libbcachefs/movinggc.c
diff --git a/libbcachefs/movinggc.h b/c_src/libbcachefs/movinggc.h
similarity index 100%
rename from libbcachefs/movinggc.h
rename to c_src/libbcachefs/movinggc.h
diff --git a/libbcachefs/nocow_locking.c b/c_src/libbcachefs/nocow_locking.c
similarity index 100%
rename from libbcachefs/nocow_locking.c
rename to c_src/libbcachefs/nocow_locking.c
diff --git a/libbcachefs/nocow_locking.h b/c_src/libbcachefs/nocow_locking.h
similarity index 100%
rename from libbcachefs/nocow_locking.h
rename to c_src/libbcachefs/nocow_locking.h
diff --git a/libbcachefs/nocow_locking_types.h b/c_src/libbcachefs/nocow_locking_types.h
similarity index 100%
rename from libbcachefs/nocow_locking_types.h
rename to c_src/libbcachefs/nocow_locking_types.h
diff --git a/libbcachefs/opts.c b/c_src/libbcachefs/opts.c
similarity index 100%
rename from libbcachefs/opts.c
rename to c_src/libbcachefs/opts.c
diff --git a/libbcachefs/opts.h b/c_src/libbcachefs/opts.h
similarity index 100%
rename from libbcachefs/opts.h
rename to c_src/libbcachefs/opts.h
diff --git a/libbcachefs/printbuf.c b/c_src/libbcachefs/printbuf.c
similarity index 100%
rename from libbcachefs/printbuf.c
rename to c_src/libbcachefs/printbuf.c
diff --git a/libbcachefs/printbuf.h b/c_src/libbcachefs/printbuf.h
similarity index 100%
rename from libbcachefs/printbuf.h
rename to c_src/libbcachefs/printbuf.h
diff --git a/libbcachefs/quota.c b/c_src/libbcachefs/quota.c
similarity index 100%
rename from libbcachefs/quota.c
rename to c_src/libbcachefs/quota.c
diff --git a/libbcachefs/quota.h b/c_src/libbcachefs/quota.h
similarity index 100%
rename from libbcachefs/quota.h
rename to c_src/libbcachefs/quota.h
diff --git a/libbcachefs/quota_types.h b/c_src/libbcachefs/quota_types.h
similarity index 100%
rename from libbcachefs/quota_types.h
rename to c_src/libbcachefs/quota_types.h
diff --git a/libbcachefs/rebalance.c b/c_src/libbcachefs/rebalance.c
similarity index 100%
rename from libbcachefs/rebalance.c
rename to c_src/libbcachefs/rebalance.c
diff --git a/libbcachefs/rebalance.h b/c_src/libbcachefs/rebalance.h
similarity index 100%
rename from libbcachefs/rebalance.h
rename to c_src/libbcachefs/rebalance.h
diff --git a/libbcachefs/rebalance_types.h b/c_src/libbcachefs/rebalance_types.h
similarity index 100%
rename from libbcachefs/rebalance_types.h
rename to c_src/libbcachefs/rebalance_types.h
diff --git a/libbcachefs/recovery.c b/c_src/libbcachefs/recovery.c
similarity index 100%
rename from libbcachefs/recovery.c
rename to c_src/libbcachefs/recovery.c
diff --git a/libbcachefs/recovery.h b/c_src/libbcachefs/recovery.h
similarity index 100%
rename from libbcachefs/recovery.h
rename to c_src/libbcachefs/recovery.h
diff --git a/libbcachefs/recovery_types.h b/c_src/libbcachefs/recovery_types.h
similarity index 100%
rename from libbcachefs/recovery_types.h
rename to c_src/libbcachefs/recovery_types.h
diff --git a/libbcachefs/reflink.c b/c_src/libbcachefs/reflink.c
similarity index 100%
rename from libbcachefs/reflink.c
rename to c_src/libbcachefs/reflink.c
diff --git a/libbcachefs/reflink.h b/c_src/libbcachefs/reflink.h
similarity index 100%
rename from libbcachefs/reflink.h
rename to c_src/libbcachefs/reflink.h
diff --git a/libbcachefs/replicas.c b/c_src/libbcachefs/replicas.c
similarity index 100%
rename from libbcachefs/replicas.c
rename to c_src/libbcachefs/replicas.c
diff --git a/libbcachefs/replicas.h b/c_src/libbcachefs/replicas.h
similarity index 100%
rename from libbcachefs/replicas.h
rename to c_src/libbcachefs/replicas.h
diff --git a/libbcachefs/replicas_types.h b/c_src/libbcachefs/replicas_types.h
similarity index 100%
rename from libbcachefs/replicas_types.h
rename to c_src/libbcachefs/replicas_types.h
diff --git a/libbcachefs/sb-clean.c b/c_src/libbcachefs/sb-clean.c
similarity index 100%
rename from libbcachefs/sb-clean.c
rename to c_src/libbcachefs/sb-clean.c
diff --git a/libbcachefs/sb-clean.h b/c_src/libbcachefs/sb-clean.h
similarity index 100%
rename from libbcachefs/sb-clean.h
rename to c_src/libbcachefs/sb-clean.h
diff --git a/libbcachefs/sb-downgrade.c b/c_src/libbcachefs/sb-downgrade.c
similarity index 100%
rename from libbcachefs/sb-downgrade.c
rename to c_src/libbcachefs/sb-downgrade.c
diff --git a/libbcachefs/sb-downgrade.h b/c_src/libbcachefs/sb-downgrade.h
similarity index 100%
rename from libbcachefs/sb-downgrade.h
rename to c_src/libbcachefs/sb-downgrade.h
diff --git a/libbcachefs/sb-errors.c b/c_src/libbcachefs/sb-errors.c
similarity index 100%
rename from libbcachefs/sb-errors.c
rename to c_src/libbcachefs/sb-errors.c
diff --git a/libbcachefs/sb-errors.h b/c_src/libbcachefs/sb-errors.h
similarity index 100%
rename from libbcachefs/sb-errors.h
rename to c_src/libbcachefs/sb-errors.h
diff --git a/libbcachefs/sb-errors_types.h b/c_src/libbcachefs/sb-errors_types.h
similarity index 100%
rename from libbcachefs/sb-errors_types.h
rename to c_src/libbcachefs/sb-errors_types.h
diff --git a/libbcachefs/sb-members.c b/c_src/libbcachefs/sb-members.c
similarity index 100%
rename from libbcachefs/sb-members.c
rename to c_src/libbcachefs/sb-members.c
diff --git a/libbcachefs/sb-members.h b/c_src/libbcachefs/sb-members.h
similarity index 100%
rename from libbcachefs/sb-members.h
rename to c_src/libbcachefs/sb-members.h
diff --git a/libbcachefs/seqmutex.h b/c_src/libbcachefs/seqmutex.h
similarity index 100%
rename from libbcachefs/seqmutex.h
rename to c_src/libbcachefs/seqmutex.h
diff --git a/libbcachefs/siphash.c b/c_src/libbcachefs/siphash.c
similarity index 100%
rename from libbcachefs/siphash.c
rename to c_src/libbcachefs/siphash.c
diff --git a/libbcachefs/siphash.h b/c_src/libbcachefs/siphash.h
similarity index 100%
rename from libbcachefs/siphash.h
rename to c_src/libbcachefs/siphash.h
diff --git a/libbcachefs/six.c b/c_src/libbcachefs/six.c
similarity index 100%
rename from libbcachefs/six.c
rename to c_src/libbcachefs/six.c
diff --git a/libbcachefs/six.h b/c_src/libbcachefs/six.h
similarity index 100%
rename from libbcachefs/six.h
rename to c_src/libbcachefs/six.h
diff --git a/libbcachefs/snapshot.c b/c_src/libbcachefs/snapshot.c
similarity index 100%
rename from libbcachefs/snapshot.c
rename to c_src/libbcachefs/snapshot.c
diff --git a/libbcachefs/snapshot.h b/c_src/libbcachefs/snapshot.h
similarity index 100%
rename from libbcachefs/snapshot.h
rename to c_src/libbcachefs/snapshot.h
diff --git a/libbcachefs/str_hash.h b/c_src/libbcachefs/str_hash.h
similarity index 100%
rename from libbcachefs/str_hash.h
rename to c_src/libbcachefs/str_hash.h
diff --git a/libbcachefs/subvolume.c b/c_src/libbcachefs/subvolume.c
similarity index 100%
rename from libbcachefs/subvolume.c
rename to c_src/libbcachefs/subvolume.c
diff --git a/libbcachefs/subvolume.h b/c_src/libbcachefs/subvolume.h
similarity index 100%
rename from libbcachefs/subvolume.h
rename to c_src/libbcachefs/subvolume.h
diff --git a/libbcachefs/subvolume_types.h b/c_src/libbcachefs/subvolume_types.h
similarity index 100%
rename from libbcachefs/subvolume_types.h
rename to c_src/libbcachefs/subvolume_types.h
diff --git a/libbcachefs/super-io.c b/c_src/libbcachefs/super-io.c
similarity index 100%
rename from libbcachefs/super-io.c
rename to c_src/libbcachefs/super-io.c
diff --git a/libbcachefs/super-io.h b/c_src/libbcachefs/super-io.h
similarity index 100%
rename from libbcachefs/super-io.h
rename to c_src/libbcachefs/super-io.h
diff --git a/libbcachefs/super.c b/c_src/libbcachefs/super.c
similarity index 100%
rename from libbcachefs/super.c
rename to c_src/libbcachefs/super.c
diff --git a/libbcachefs/super.h b/c_src/libbcachefs/super.h
similarity index 100%
rename from libbcachefs/super.h
rename to c_src/libbcachefs/super.h
diff --git a/libbcachefs/super_types.h b/c_src/libbcachefs/super_types.h
similarity index 100%
rename from libbcachefs/super_types.h
rename to c_src/libbcachefs/super_types.h
diff --git a/libbcachefs/sysfs.c b/c_src/libbcachefs/sysfs.c
similarity index 100%
rename from libbcachefs/sysfs.c
rename to c_src/libbcachefs/sysfs.c
diff --git a/libbcachefs/sysfs.h b/c_src/libbcachefs/sysfs.h
similarity index 100%
rename from libbcachefs/sysfs.h
rename to c_src/libbcachefs/sysfs.h
diff --git a/libbcachefs/tests.c b/c_src/libbcachefs/tests.c
similarity index 100%
rename from libbcachefs/tests.c
rename to c_src/libbcachefs/tests.c
diff --git a/libbcachefs/tests.h b/c_src/libbcachefs/tests.h
similarity index 100%
rename from libbcachefs/tests.h
rename to c_src/libbcachefs/tests.h
diff --git a/libbcachefs/thread_with_file.c b/c_src/libbcachefs/thread_with_file.c
similarity index 100%
rename from libbcachefs/thread_with_file.c
rename to c_src/libbcachefs/thread_with_file.c
diff --git a/libbcachefs/thread_with_file.h b/c_src/libbcachefs/thread_with_file.h
similarity index 100%
rename from libbcachefs/thread_with_file.h
rename to c_src/libbcachefs/thread_with_file.h
diff --git a/libbcachefs/thread_with_file_types.h b/c_src/libbcachefs/thread_with_file_types.h
similarity index 100%
rename from libbcachefs/thread_with_file_types.h
rename to c_src/libbcachefs/thread_with_file_types.h
diff --git a/libbcachefs/trace.c b/c_src/libbcachefs/trace.c
similarity index 100%
rename from libbcachefs/trace.c
rename to c_src/libbcachefs/trace.c
diff --git a/libbcachefs/trace.h b/c_src/libbcachefs/trace.h
similarity index 100%
rename from libbcachefs/trace.h
rename to c_src/libbcachefs/trace.h
diff --git a/libbcachefs/two_state_shared_lock.c b/c_src/libbcachefs/two_state_shared_lock.c
similarity index 100%
rename from libbcachefs/two_state_shared_lock.c
rename to c_src/libbcachefs/two_state_shared_lock.c
diff --git a/libbcachefs/two_state_shared_lock.h b/c_src/libbcachefs/two_state_shared_lock.h
similarity index 100%
rename from libbcachefs/two_state_shared_lock.h
rename to c_src/libbcachefs/two_state_shared_lock.h
diff --git a/libbcachefs/util.c b/c_src/libbcachefs/util.c
similarity index 100%
rename from libbcachefs/util.c
rename to c_src/libbcachefs/util.c
diff --git a/libbcachefs/util.h b/c_src/libbcachefs/util.h
similarity index 100%
rename from libbcachefs/util.h
rename to c_src/libbcachefs/util.h
diff --git a/libbcachefs/varint.c b/c_src/libbcachefs/varint.c
similarity index 100%
rename from libbcachefs/varint.c
rename to c_src/libbcachefs/varint.c
diff --git a/libbcachefs/varint.h b/c_src/libbcachefs/varint.h
similarity index 100%
rename from libbcachefs/varint.h
rename to c_src/libbcachefs/varint.h
diff --git a/libbcachefs/vstructs.h b/c_src/libbcachefs/vstructs.h
similarity index 100%
rename from libbcachefs/vstructs.h
rename to c_src/libbcachefs/vstructs.h
diff --git a/libbcachefs/xattr.c b/c_src/libbcachefs/xattr.c
similarity index 100%
rename from libbcachefs/xattr.c
rename to c_src/libbcachefs/xattr.c
diff --git a/libbcachefs/xattr.h b/c_src/libbcachefs/xattr.h
similarity index 100%
rename from libbcachefs/xattr.h
rename to c_src/libbcachefs/xattr.h
diff --git a/linux/atomic64.c b/c_src/linux/atomic64.c
similarity index 100%
rename from linux/atomic64.c
rename to c_src/linux/atomic64.c
diff --git a/linux/bio.c b/c_src/linux/bio.c
similarity index 100%
rename from linux/bio.c
rename to c_src/linux/bio.c
diff --git a/linux/blkdev.c b/c_src/linux/blkdev.c
similarity index 100%
rename from linux/blkdev.c
rename to c_src/linux/blkdev.c
diff --git a/linux/closure.c b/c_src/linux/closure.c
similarity index 100%
rename from linux/closure.c
rename to c_src/linux/closure.c
diff --git a/linux/crc64.c b/c_src/linux/crc64.c
similarity index 100%
rename from linux/crc64.c
rename to c_src/linux/crc64.c
diff --git a/linux/crc64table.h b/c_src/linux/crc64table.h
similarity index 100%
rename from linux/crc64table.h
rename to c_src/linux/crc64table.h
diff --git a/linux/crypto/api.c b/c_src/linux/crypto/api.c
similarity index 100%
rename from linux/crypto/api.c
rename to c_src/linux/crypto/api.c
diff --git a/linux/crypto/chacha20_generic.c b/c_src/linux/crypto/chacha20_generic.c
similarity index 100%
rename from linux/crypto/chacha20_generic.c
rename to c_src/linux/crypto/chacha20_generic.c
diff --git a/linux/crypto/poly1305_generic.c b/c_src/linux/crypto/poly1305_generic.c
similarity index 100%
rename from linux/crypto/poly1305_generic.c
rename to c_src/linux/crypto/poly1305_generic.c
diff --git a/linux/crypto/sha256_generic.c b/c_src/linux/crypto/sha256_generic.c
similarity index 100%
rename from linux/crypto/sha256_generic.c
rename to c_src/linux/crypto/sha256_generic.c
diff --git a/linux/fs.c b/c_src/linux/fs.c
similarity index 100%
rename from linux/fs.c
rename to c_src/linux/fs.c
diff --git a/linux/generic-radix-tree.c b/c_src/linux/generic-radix-tree.c
similarity index 100%
rename from linux/generic-radix-tree.c
rename to c_src/linux/generic-radix-tree.c
diff --git a/linux/int_sqrt.c b/c_src/linux/int_sqrt.c
similarity index 100%
rename from linux/int_sqrt.c
rename to c_src/linux/int_sqrt.c
diff --git a/linux/kstrtox.c b/c_src/linux/kstrtox.c
similarity index 100%
rename from linux/kstrtox.c
rename to c_src/linux/kstrtox.c
diff --git a/linux/kstrtox.h b/c_src/linux/kstrtox.h
similarity index 100%
rename from linux/kstrtox.h
rename to c_src/linux/kstrtox.h
diff --git a/linux/kthread.c b/c_src/linux/kthread.c
similarity index 100%
rename from linux/kthread.c
rename to c_src/linux/kthread.c
diff --git a/linux/llist.c b/c_src/linux/llist.c
similarity index 100%
rename from linux/llist.c
rename to c_src/linux/llist.c
diff --git a/linux/mempool.c b/c_src/linux/mempool.c
similarity index 100%
rename from linux/mempool.c
rename to c_src/linux/mempool.c
diff --git a/linux/preempt.c b/c_src/linux/preempt.c
similarity index 100%
rename from linux/preempt.c
rename to c_src/linux/preempt.c
diff --git a/linux/ratelimit.c b/c_src/linux/ratelimit.c
similarity index 100%
rename from linux/ratelimit.c
rename to c_src/linux/ratelimit.c
diff --git a/linux/rhashtable.c b/c_src/linux/rhashtable.c
similarity index 100%
rename from linux/rhashtable.c
rename to c_src/linux/rhashtable.c
diff --git a/linux/sched.c b/c_src/linux/sched.c
similarity index 100%
rename from linux/sched.c
rename to c_src/linux/sched.c
diff --git a/linux/semaphore.c b/c_src/linux/semaphore.c
similarity index 100%
rename from linux/semaphore.c
rename to c_src/linux/semaphore.c
diff --git a/linux/seq_buf.c b/c_src/linux/seq_buf.c
similarity index 100%
rename from linux/seq_buf.c
rename to c_src/linux/seq_buf.c
diff --git a/linux/shrinker.c b/c_src/linux/shrinker.c
similarity index 100%
rename from linux/shrinker.c
rename to c_src/linux/shrinker.c
diff --git a/linux/siphash.c b/c_src/linux/siphash.c
similarity index 100%
rename from linux/siphash.c
rename to c_src/linux/siphash.c
diff --git a/linux/string.c b/c_src/linux/string.c
similarity index 100%
rename from linux/string.c
rename to c_src/linux/string.c
diff --git a/linux/string_helpers.c b/c_src/linux/string_helpers.c
similarity index 100%
rename from linux/string_helpers.c
rename to c_src/linux/string_helpers.c
diff --git a/linux/timer.c b/c_src/linux/timer.c
similarity index 100%
rename from linux/timer.c
rename to c_src/linux/timer.c
diff --git a/linux/wait.c b/c_src/linux/wait.c
similarity index 100%
rename from linux/wait.c
rename to c_src/linux/wait.c
diff --git a/linux/workqueue.c b/c_src/linux/workqueue.c
similarity index 100%
rename from linux/workqueue.c
rename to c_src/linux/workqueue.c
diff --git a/linux/xxhash.c b/c_src/linux/xxhash.c
similarity index 100%
rename from linux/xxhash.c
rename to c_src/linux/xxhash.c
diff --git a/linux/zstd_compress_module.c b/c_src/linux/zstd_compress_module.c
similarity index 100%
rename from linux/zstd_compress_module.c
rename to c_src/linux/zstd_compress_module.c
diff --git a/linux/zstd_decompress_module.c b/c_src/linux/zstd_decompress_module.c
similarity index 100%
rename from linux/zstd_decompress_module.c
rename to c_src/linux/zstd_decompress_module.c
diff --git a/qcow2.c b/c_src/qcow2.c
similarity index 100%
rename from qcow2.c
rename to c_src/qcow2.c
diff --git a/qcow2.h b/c_src/qcow2.h
similarity index 100%
rename from qcow2.h
rename to c_src/qcow2.h
diff --git a/raid/COPYING b/c_src/raid/COPYING
similarity index 100%
rename from raid/COPYING
rename to c_src/raid/COPYING
diff --git a/raid/check.c b/c_src/raid/check.c
similarity index 100%
rename from raid/check.c
rename to c_src/raid/check.c
diff --git a/raid/combo.h b/c_src/raid/combo.h
similarity index 100%
rename from raid/combo.h
rename to c_src/raid/combo.h
diff --git a/raid/cpu.h b/c_src/raid/cpu.h
similarity index 100%
rename from raid/cpu.h
rename to c_src/raid/cpu.h
diff --git a/raid/gf.h b/c_src/raid/gf.h
similarity index 100%
rename from raid/gf.h
rename to c_src/raid/gf.h
diff --git a/raid/helper.c b/c_src/raid/helper.c
similarity index 100%
rename from raid/helper.c
rename to c_src/raid/helper.c
diff --git a/raid/helper.h b/c_src/raid/helper.h
similarity index 100%
rename from raid/helper.h
rename to c_src/raid/helper.h
diff --git a/raid/int.c b/c_src/raid/int.c
similarity index 100%
rename from raid/int.c
rename to c_src/raid/int.c
diff --git a/raid/internal.h b/c_src/raid/internal.h
similarity index 100%
rename from raid/internal.h
rename to c_src/raid/internal.h
diff --git a/raid/intz.c b/c_src/raid/intz.c
similarity index 100%
rename from raid/intz.c
rename to c_src/raid/intz.c
diff --git a/raid/memory.c b/c_src/raid/memory.c
similarity index 100%
rename from raid/memory.c
rename to c_src/raid/memory.c
diff --git a/raid/memory.h b/c_src/raid/memory.h
similarity index 100%
rename from raid/memory.h
rename to c_src/raid/memory.h
diff --git a/raid/module.c b/c_src/raid/module.c
similarity index 100%
rename from raid/module.c
rename to c_src/raid/module.c
diff --git a/raid/raid.c b/c_src/raid/raid.c
similarity index 100%
rename from raid/raid.c
rename to c_src/raid/raid.c
diff --git a/raid/raid.h b/c_src/raid/raid.h
similarity index 100%
rename from raid/raid.h
rename to c_src/raid/raid.h
diff --git a/raid/tables.c b/c_src/raid/tables.c
similarity index 100%
rename from raid/tables.c
rename to c_src/raid/tables.c
diff --git a/raid/tag.c b/c_src/raid/tag.c
similarity index 100%
rename from raid/tag.c
rename to c_src/raid/tag.c
diff --git a/raid/test.c b/c_src/raid/test.c
similarity index 100%
rename from raid/test.c
rename to c_src/raid/test.c
diff --git a/raid/test.h b/c_src/raid/test.h
similarity index 100%
rename from raid/test.h
rename to c_src/raid/test.h
diff --git a/raid/x86.c b/c_src/raid/x86.c
similarity index 100%
rename from raid/x86.c
rename to c_src/raid/x86.c
diff --git a/raid/x86z.c b/c_src/raid/x86z.c
similarity index 100%
rename from raid/x86z.c
rename to c_src/raid/x86z.c
diff --git a/tools-util.c b/c_src/tools-util.c
similarity index 100%
rename from tools-util.c
rename to c_src/tools-util.c
diff --git a/tools-util.h b/c_src/tools-util.h
similarity index 100%
rename from tools-util.h
rename to c_src/tools-util.h
diff --git a/make-release-tarball.sh b/make-release-tarball.sh
index 32e4772..c468da7 100755
--- a/make-release-tarball.sh
+++ b/make-release-tarball.sh
@@ -7,7 +7,7 @@ version=$1
 git checkout v$version
 git clean -xfd
 
-(cd rust-src; cargo license) > COPYING.rust-dependencies
+cargo license > COPYING.rust-dependencies
 
 git ls-files|
     tar --create --file bcachefs-tools-$version.tar -T -	\
@@ -28,7 +28,7 @@ scp bcachefs-tools-$version.tar.zst	evilpiepirate.org:/var/www/htdocs/bcachefs-t
 scp bcachefs-tools-$version.tar.asc	evilpiepirate.org:/var/www/htdocs/bcachefs-tools/
 scp bcachefs-tools-$version.tar.sign	evilpiepirate.org:/var/www/htdocs/bcachefs-tools/
 
-cargo vendor --manifest-path rust-src/Cargo.toml
+cargo vendor
 
 mkdir .cargo
 cat > .cargo/config.toml <<-ZZ
diff --git a/rust-src/.gitignore b/rust-src/.gitignore
deleted file mode 100644
index 644cd42..0000000
--- a/rust-src/.gitignore
+++ /dev/null
@@ -1,15 +0,0 @@
-# Generated by Cargo
-# will have compiled files and executables
-debug/
-target/
-
-# Remove Cargo.lock from gitignore if creating an executable, leave it for libraries
-# More information here https://doc.rust-lang.org/cargo/guide/cargo-toml-vs-cargo-lock.html
-# Needed by nix
-# Cargo.lock
-
-# These are backup files generated by rustfmt
-**/*.rs.bk
-
-# MSVC Windows builds of rustc generate these, which store debugging information
-*.pdb
diff --git a/rust-src/README.md b/rust-src/README.md
deleted file mode 100644
index e4700f6..0000000
--- a/rust-src/README.md
+++ /dev/null
@@ -1,62 +0,0 @@
-Usage
-=====
-
-```
-bcachefs-mount 0.1.0
-Mount a bcachefs filesystem by its UUID
-
-USAGE:
-    bcachefs-mount [OPTIONS] <uuid> <mountpoint>
-
-FLAGS:
-    -h, --help       
-            Prints help information
-
-    -V, --version    
-            Prints version information
-
-
-OPTIONS:
-    -o <options>                 
-            Mount options [default: ]
-
-    -p, --password <password>    
-            Where the password would be loaded from.
-            
-            Possible values are: "fail" - don't ask for password, fail if filesystem is encrypted; "wait" - wait for
-            password to become available before mounting; "ask" -  prompt the user for password; [default: fail]
-
-ARGS:
-    <uuid>          
-            External UUID of the bcachefs filesystem
-
-    <mountpoint>    
-            Where the filesystem should be mounted
-```
-
-Caveats
-=======
-
-* `--password ask` is not yet implemented, but you can use `--password wait`, and load the key with `bcachefs unlock`.
-
-Build
-=====
-
-```sh
-$ git submodule update --init --recursive
-$ cargo build --release
-```
-
-Binary will be built in `target/release/bcachefs-mount`
-
-Dependencies:
-
-* rust
-* blkid
-* uuid
-* liburcu
-* libsodium
-* zlib
-* liblz4
-* libzstd
-* libkeyutils
diff --git a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h b/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
deleted file mode 100644
index 5fb4261..0000000
--- a/rust-src/bch_bindgen/src/libbcachefs_wrapper.h
+++ /dev/null
@@ -1,22 +0,0 @@
-#include "../libbcachefs/super-io.h"
-#include "../libbcachefs/checksum.h"
-#include "../libbcachefs/bcachefs_format.h"
-#include "../libbcachefs/btree_cache.h"
-#include "../libbcachefs/btree_iter.h"
-#include "../libbcachefs/debug.h"
-#include "../libbcachefs/errcode.h"
-#include "../libbcachefs/error.h"
-#include "../libbcachefs/opts.h"
-#include "../libbcachefs.h"
-#include "../crypto.h"
-#include "../include/linux/bio.h"
-#include "../include/linux/blkdev.h"
-#include "../cmds.h"
-#include "../raid/raid.h"
-
-
-#define MARK_FIX_753(req_name) const blk_mode_t Fix753_##req_name = req_name;
-
-MARK_FIX_753(BLK_OPEN_READ);
-MARK_FIX_753(BLK_OPEN_WRITE);
-MARK_FIX_753(BLK_OPEN_EXCL);
diff --git a/rust-src/rustfmt.toml b/rustfmt.toml
similarity index 100%
rename from rust-src/rustfmt.toml
rename to rustfmt.toml
diff --git a/rust-src/src/bcachefs.rs b/src/bcachefs.rs
similarity index 100%
rename from rust-src/src/bcachefs.rs
rename to src/bcachefs.rs
diff --git a/rust-src/src/commands/cmd_completions.rs b/src/commands/cmd_completions.rs
similarity index 100%
rename from rust-src/src/commands/cmd_completions.rs
rename to src/commands/cmd_completions.rs
diff --git a/rust-src/src/commands/cmd_list.rs b/src/commands/cmd_list.rs
similarity index 100%
rename from rust-src/src/commands/cmd_list.rs
rename to src/commands/cmd_list.rs
diff --git a/rust-src/src/commands/cmd_mount.rs b/src/commands/cmd_mount.rs
similarity index 100%
rename from rust-src/src/commands/cmd_mount.rs
rename to src/commands/cmd_mount.rs
diff --git a/rust-src/src/commands/logger.rs b/src/commands/logger.rs
similarity index 100%
rename from rust-src/src/commands/logger.rs
rename to src/commands/logger.rs
diff --git a/rust-src/src/commands/mod.rs b/src/commands/mod.rs
similarity index 100%
rename from rust-src/src/commands/mod.rs
rename to src/commands/mod.rs
diff --git a/rust-src/src/key.rs b/src/key.rs
similarity index 100%
rename from rust-src/src/key.rs
rename to src/key.rs
diff --git a/tests/util.py b/tests/util.py
index 3ec38b2..68fe9e9 100644
--- a/tests/util.py
+++ b/tests/util.py
@@ -11,7 +11,7 @@ import time
 from pathlib import Path
 
 BASE_PATH= os.path.dirname(__file__)
-BCH_PATH = os.path.abspath(os.path.join(BASE_PATH, '../rust-src/target/release', 'bcachefs'))
+BCH_PATH = os.path.abspath(os.path.join(BASE_PATH, '../target/release', 'bcachefs'))
 VALGRIND_PATH= os.path.abspath(os.path.join(BASE_PATH,
     'valgrind-suppressions.txt'))
 
-- 
2.43.0

