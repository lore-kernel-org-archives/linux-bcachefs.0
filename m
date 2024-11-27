Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BACD1FBCA4
	for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 12:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732711985; cv=none; b=bqu6Ex9W+rhGM2hIDQijwmrXOAW27schBNJ5yvPPHd83JWt7S+gIq60UJX2LLsCzZSi+H4glULODd79N2Dbib1NzbwigDRRx0evk00voxfnV+c7V2tXb/TFHim/FTc1SDLxERE3FxiMviVXtRb7pEXMbHjZhJilG0il2ZvKs7fY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732711985; c=relaxed/simple;
	bh=xjPIjiSLj2qSUGGn3KuFkn/JtDdj5QT2U5LNX0c/IoY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=hw3pKWc3yApUOzAikDydhaWocdUs81qy+OpVMq6eOCOTo38Onk8pPDP+nCrhVZinoua/txhtsdXMp9FqFEx7gDZEjWPWSxbpToOacN1MBwWi9rTUyGeLwdGBJQqtEsTq2s9U13ulk3UVdKzkdR4w5uXdkPuYaL0D2OIa28wVCPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3a768b62268so75130685ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 27 Nov 2024 04:53:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732711982; x=1733316782;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d04jGaNrIT6mQifbCfwGC0CEwBJsC/NBvU26ZyXmy18=;
        b=STaAiA5yvFLukLbAzO97BuRgo07hiY15T3j+t0TLfzrkOWGjfb7s7Q4m8UIIjD8Rnb
         Ly4TLE0UtI0KxlTNWxkkvGlARJRuvx1QaLpKm/DtHIj60YJ5RIq8fGKkTkv8Ekjix8XK
         EFCzef1dYZahG5PbZleh2sB0lrGLgTK2l+5nzcLrVwAbHYTLLVb46Tf+Ume/d7YxWfJU
         cYkYMDRKUlEAvgM55JJi81EIg8cnCXRb/Rxz4dIPEcS0HTmlwPYuAo4TPIQ/XMB3YwBQ
         HO18drAJrGOalBru+XxcGpbdnbz9fpjyjUHsKcKh5+CRzQKVwB9Ovrm1lGY/AhHbSO1R
         i3+w==
X-Forwarded-Encrypted: i=1; AJvYcCX+K0BfX4Pe33ZZR/WeYvHMYXo2a9fB7In0yuYyL6fxoP2PqkWfGcGb5oqPwHTD2CJHWx0B/Iq42J737ssWGQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy8YeXrw0zcXU6AQlA06yBriXyspKYonh21dmqW+9ZFYKoBwpZ/
	3cBj9sOMv3LwGlpwplW5xTZsvsH5lXJoP8lN9nK6dbtlSwMem83KjOc1ctnMc+4ZDaH2XhDAEAF
	lkjID7ZRWKmq0gH9g3Ve8hS//YXA4ZLMgUn2IS16x2kZwIV3dIR6RsXk=
X-Google-Smtp-Source: AGHT+IHFbYN4PHoZhAy2Ap0eVBG57YJgaBuU4VAYOcRbFvC6ua7Sf8lpRHfa1f+KL3Ku8bbnxFWWi964nH4c5eaAmANGcMdy1agt
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca0e:0:b0:3a7:635e:d365 with SMTP id
 e9e14a558f8ab-3a7c5540e9cmr37418815ab.6.1732711982732; Wed, 27 Nov 2024
 04:53:02 -0800 (PST)
Date: Wed, 27 Nov 2024 04:53:02 -0800
In-Reply-To: <67447b76.050a0220.1cc393.0086.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6747162e.050a0220.1286eb.0031.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] BUG: corrupted list in bch2_btree_and_journal_iter_exit
From: syzbot <syzbot+2f7c2225ed8a5cb24af1@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d1adfe4e7e4e7ea225547a07c4b79c314c50c6fb
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Apr 7 03:26:36 2024 +0000

    bcachefs: move root node topo checks to node_check_topology()

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=17e6e1e8580000
start commit:   9f16d5e6f220 Merge tag 'for-linus' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1416e1e8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1016e1e8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e92fc420ca55fe33
dashboard link: https://syzkaller.appspot.com/bug?extid=2f7c2225ed8a5cb24af1
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16cf575f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14be0530580000

Reported-by: syzbot+2f7c2225ed8a5cb24af1@syzkaller.appspotmail.com
Fixes: d1adfe4e7e4e ("bcachefs: move root node topo checks to node_check_topology()")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
