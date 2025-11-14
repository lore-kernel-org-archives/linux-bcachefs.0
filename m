Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E460136358
	for <linux-bcachefs@vger.kernel.org>; Fri, 14 Nov 2025 12:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763122626; cv=none; b=iiAaUqmLpqBq5NfDgxKa365b9xUUtEiLfmaPdJ6vWqLITWWNUc4CbvefICc+dvH3lsEF5TztZC9bjF4htO6L42yGqZPFshK8yEEr4CKpsh0+qapU7GW0Dj0vGxFn0Kr261OzJPxf4eXkH9ScsObtcC+hJfC00mC6YbDxGobIkM0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763122626; c=relaxed/simple;
	bh=663ipmP+LqFIfwz8A1AMV9/pVMeMoOfjb9XLK1nwaS0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=dYFRI3Upu6qPLFxvwXcA8tKEFwal7hplR+Ak/kl2wd9AJpx6eV45jXbe/vwxJ6aXe2oic1UbnfVUsDUgNyS77QOdSWug5vQyl+nwkDzDKF7BtTIIN6IZhXJqn/EOQVdr38fuZCYAEMcTyf+PbKS+ifoF9Bjgds92IvyDUEBwcP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-940d88b8c15so193445239f.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 14 Nov 2025 04:17:04 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763122623; x=1763727423;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TFgQm/VGE5Xs03bcN+eSBth3C//vHy2AQ6dhR7AblGc=;
        b=CTcbL4v55STgOiwerqezWM34y5XG0UKZ4Kcy8OpEDMTpwSC0ayy0rR2Iu0si2NAJgX
         rRO/lnDYptPcWM1R/e5fB7XrvzjY94TgnKsIUO/x7lfiBdtTsgC8J95FhEhZ5Qs92CAo
         x84pcVUdZZMHbOxEl3OsPyFp5IFD0INetiFCBT+qmW4y9AsdUF2vuETals5TPeME+OyE
         h6IV6S+o6LUBuG772CNE5K9scwtET/ABMCd7z84Lovk5w/l+gKgKtygdE7zD3/fV6hrm
         wummbYoyCb9gR2nhDhAoKGMjUSFwH6dbxOziPpFA8a7NEkHrMLyzULq8GcgUas2bJr3M
         ID0A==
X-Forwarded-Encrypted: i=1; AJvYcCWw8rKSdSQHYpZarCUwnRNs7+U5GPC3C7AwzfQ66tXSnGSqvnz+HQv0Lv5OYtfDLUDW/5swEjwvgz8tndN3hQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyS3Gcg9dj0GN94/PeO4OO20vPkdFJiqeYywX+SL9q/kbJug9HQ
	RdKwsm3Z3ttBM92tzbrlcnFF5vId5zJC5GDrsO/AgNq4IzYg7Wf3Nf6dh3XE16dXVMjFz4X1s2c
	OPyjt82kkVvjO9w6ZIZanm2e2KdlVzHl6If2bAHCD/kT1qgXJ7kANR/fr+j0=
X-Google-Smtp-Source: AGHT+IFxIvXsLCDaf8O+ewJ3VI2riovx6Zc3UNlnra6H1giAuuMOCPLzbsRsOvpDd66L3TkUV1TU+77NbpL88apj5WC+qHrJiEKS
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c11:b0:948:a532:a30a with SMTP id
 ca18e2360f4ac-948e0cc9142mr411020939f.1.1763122622883; Fri, 14 Nov 2025
 04:17:02 -0800 (PST)
Date: Fri, 14 Nov 2025 04:17:02 -0800
In-Reply-To: <68bad556.a00a0220.eb3d.0013.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69171dbe.a70a0220.3124cb.005c.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_path_level_init (4)
From: syzbot <syzbot+55c84106264e92ea9ada@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ssrane_b23@ee.vjti.ac.in, 
	syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit f2c61db29f277b9c80de92102fc532cc247495cd
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon Sep 29 20:43:52 2025 +0000

    Remove bcachefs core code

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=100837cd980000
start commit:   d69eb204c255 Merge tag 'net-6.17-rc5' of git://git.kernel...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
dashboard link: https://syzkaller.appspot.com/bug?extid=55c84106264e92ea9ada
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1788c962580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12b0887c580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: Remove bcachefs core code

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
