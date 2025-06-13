Received: from mail-il1-f208.google.com (mail-il1-f208.google.com [209.85.166.208])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 961DF1F30A9
	for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 17:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.208
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749837033; cv=none; b=d/6hfwZbJqelfXz0lGg+NVKSgjDWd1YsAd55/H94QRRy67Pz4vH0JPh/aTkpECZ9SANZUFQL/Zpc2ZEae5WVzXmBn/K7l9Ppmq2qE9WeZvufVBQnmCss6tDifKbkeeTB6czVriUsjmJj3CP/ZBGW1LLUK0cdNFTspeA8eQE9nnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749837033; c=relaxed/simple;
	bh=wBcluHVfZDxgVBR1a8uWz3JYLXKCKsQvLm8RbgidcoA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=tgI6gRoO9kOXBZ/dCJRjQ6TD4mPqPOl/yY3lV00blmhVSsUYSHdwlWpfsf96vtkIRlmyV3gAWJyQa+h50cq98TAjueTLCEpMbzHZQLPC+B8l2LHwyFBv1GNpr7/Jy5U+L2J+U8WjXUxGK5jKrfip4goVXo/HKR0T/e8KQT0DhII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.208
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f208.google.com with SMTP id e9e14a558f8ab-3ddc9e145daso37816975ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 13 Jun 2025 10:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749837031; x=1750441831;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bwGJztskvbfBImqGnRKJLgsCOkaX/LFRrR+fiR9HybY=;
        b=TwI3Gm4wSqOlJgh7zIwjO9EI8CZ4Dk3HNYMdpkwE9s1sFWvUzd7uCSV58lanyul6z0
         iF4MQn9hj0FSAPoxWgEa9WP/SjjE5hZGA0WoqHvUz48rE4Ja0PHMbRnQu3E+nVdEDDx1
         x1iYcPxX2E6QsmmOIDBjtgE7TfctHHkvA83tSbHplg9YJdXYvYjkCJ7Bj1FubuXaxbTO
         7f9ZN0wcMFOyRj9w4fqyJD2/MDTeszEy0J1gWURV0x5slFlP49RM5QQTrrn7hv9FAlAV
         N4ppsJKkgJKkImbgxT5tWxOAMrJBAK+lpwsTCfFykYaIC+y3mDwP3WcYDhqkExWmRKUi
         fdNg==
X-Forwarded-Encrypted: i=1; AJvYcCVyT7CObltKnFqi5g+hZnALFGEsqwxF6sU8RBgCzpAP8VLgcVNyCwIrgYfHpFusavOuPgT7N6Jwp+rjhvKNJA==@vger.kernel.org
X-Gm-Message-State: AOJu0YwadOtIPeiysvJ657dn3Wy/y/xldleY1jvwGFh15ENMLXfAEe3Z
	3rFdqsh1SVq1ZMFgTHfsPSHRCEN61hflrIAFU4600vE8pwWGh+s6bCkKRMaUL3omW1tiVV8FX4G
	+9tTXF86snhKaYapwUlXV6AkmlSVKK2K0bpf9wlQkr/rUKRbtVBnImaGGfbc=
X-Google-Smtp-Source: AGHT+IEGOA5sl7U3TB9FQZZfW7xan/BqVFdapzUx/q7fhfgy8xt5Kv5UyEL6UHnCAPkPzMPyO35VapFeTZ5FeN6vrw9LS6KSJZ11
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1529:b0:3dd:b706:b7d3 with SMTP id
 e9e14a558f8ab-3de07c55935mr8227755ab.7.1749837030762; Fri, 13 Jun 2025
 10:50:30 -0700 (PDT)
Date: Fri, 13 Jun 2025 10:50:30 -0700
In-Reply-To: <684c565b.a00a0220.279073.0014.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <684c64e6.050a0220.be214.02a2.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] BUG: unable to handle kernel NULL pointer
 dereference in bch2_btree_update_start
From: syzbot <syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has found a reproducer for the following issue on:

HEAD commit:    19272b37aa4f Linux 6.16-rc1
git tree:       git://git.kernel.org/pub/scm/linux/kernel/git/arm64/linux.git for-kernelci
console output: https://syzkaller.appspot.com/x/log.txt?x=11fc310c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=8409c4d4e51ac27
dashboard link: https://syzkaller.appspot.com/bug?extid=2f3859bd28f20fa682e6
compiler:       Debian clang version 20.1.6 (++20250514063057+1e4d39e07757-1~exp1~20250514183223.118), Debian LLD 20.1.6
userspace arch: arm64
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e29e0c580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14199d70580000

Downloadable assets:
disk image: https://storage.googleapis.com/syzbot-assets/92d22b0c6493/disk-19272b37.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/3fb0142bb63a/vmlinux-19272b37.xz
kernel image: https://storage.googleapis.com/syzbot-assets/3d5f3836ae42/Image-19272b37.gz.xz
mounted in repro: https://storage.googleapis.com/syzbot-assets/4a262746417e/mount_0.gz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+2f3859bd28f20fa682e6@syzkaller.appspotmail.com

Unable to handle kernel NULL pointer dereference at virtual address 0000000000000000
Mem abort info:
  ESR = 0x0000000086000006
  EC = 0x21: IABT (current EL), IL = 32 bits
  SET = 0, FnV = 0
  EA = 0, S1PTW = 0
  FSC = 0x06: level 2 translation fault
user pgtable: 4k pages, 48-bit VAs, pgdp=0000000114af4000
[0000000000000000] pgd=08000001144e0403, p4d=08000001144e0403, pud=08000001144e1403, pmd=0000000000000000
Internal error: Oops: 0000000086000006 [#1]  SMP
Modules linked in:
CPU: 1 UID: 0 PID: 6497 Comm: syz-executor379 Not tainted 6.16.0-rc1-syzkaller-g19272b37aa4f #0 PREEMPT 
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 05/07/2025
pstate: 60400005 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : 0x0
lr : mempool_alloc_noprof+0x150/0x3f4 mm/mempool.c:402
sp : ffff8000a36a6c80
x29: ffff8000a36a6d80 x28: 0000000000000000 x27: 1fffe0001c5c07df
x26: 0000000000092800 x25: ffff7000146d4d9c x24: ffff0000e2e03ef0
x23: 0000000000092c40 x22: ffff0000e2e03ef8 x21: 0000000000000400
x20: 1fffe0001c5c07de x19: ffff0000e2e03ea0 x18: 00000000ffffffff
x17: ffff800093215000 x16: ffff80008051b344 x15: ffff800092d9eb80
x14: ffff0000c9ba0a90 x13: ffff800093014c08 x12: ffff0000c9ba0ab0
x11: 0000000000008004 x10: 0000000000ff0100 x9 : 0000000000000000
x8 : 0000000000000000 x7 : ffff800080b774a8 x6 : 0000000000000000
x5 : 0000000000000020 x4 : ffff8000a36a6a20 x3 : 0000000000000000
x2 : 0000000000000000 x1 : 0000000000000000 x0 : 0000000000092800
Call trace:
 0x0 (P)
 bch2_btree_update_start+0x488/0x1398 fs/bcachefs/btree_update_interior.c:1212
 bch2_btree_node_rewrite+0x190/0xd34 fs/bcachefs/btree_update_interior.c:2226
 bch2_move_btree+0x538/0xa8c fs/bcachefs/move.c:1145
 bch2_scan_old_btree_nodes+0x80/0x21c fs/bcachefs/move.c:1266
 bch2_data_job+0x570/0x7cc fs/bcachefs/move.c:1404
 bch2_data_thread+0xb4/0x1cc fs/bcachefs/chardev.c:315
 kthread+0x5fc/0x75c kernel/kthread.c:464
 ret_from_fork+0x10/0x20 arch/arm64/kernel/entry.S:847
Code: ???????? ???????? ???????? ???????? (????????) 
---[ end trace 0000000000000000 ]---


---
If you want syzbot to run the reproducer, reply with:
#syz test: git://repo/address.git branch-or-commit-hash
If you attach or paste a git patch, syzbot will apply it before testing.
