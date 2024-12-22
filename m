Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B16BC79D0
	for <linux-bcachefs@vger.kernel.org>; Sun, 22 Dec 2024 02:31:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734834664; cv=none; b=kadC8Sd7TL/huuYCRMWfNYvlDkxsIA2TfhbcJmJKJL9/l+OjcY22LTZ7o4+2qcFuOdc+4ABRGwS3J7lWCnSRtf//sM5PKtDDIi4cKDS0Oesd9fO1grOPTWgUyDdeha7SDfGVrfMxWCey1VI/zg8UTU2NlJBaMjoyGmuH332IorE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734834664; c=relaxed/simple;
	bh=TQVU99hHQjX4xYHZRNTW33ATS1kIDSfkPGcz+ESZEkI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=T61rm6KMOJ4nVWwNYgwFZoxzQ1Az6xWmDicEK4olGVVTChv0v/teG56ZgDpzlc43STUz9FtUoE2WStKLSBwlH3tbs8OKQOhKirVuDOeNiL5icSdkjM5tjr6KNwz4DrmPrDvZuP5I94CKoOI2NQQQyENylOTIG3Vgmc6GCBs3NQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3a814406be9so59043685ab.1
        for <linux-bcachefs@vger.kernel.org>; Sat, 21 Dec 2024 18:31:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734834662; x=1735439462;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VDmwue/8tabwT4QjeHhpdBUxNAWNF+0SK6Zi1ov0xtU=;
        b=ZoCgOkYrDjpQPFMCUrxCa1mymuW6NEi8NYSkYh9A+MU8YwJX5ZEp4Q1ywo7f1sJ6o7
         AptMLzJprkPjc8URcVhna6I2oPdvJeb8VV6MbQqD/DhtqOKg2BYY7vbc4MtYXGkn9CVI
         5ADgAGC6o5qvoRBO+ofkoRI0c85ixNPGFs4zg10WTIK+X2OSWWcpVVQ5qYYbYNmLe0n6
         8PLKsn7AkoPQFCrhZxs32SuK/8hueXh0a/r+pm2DlwTxbmL74tp8VFlw2M/dB2JzXtcq
         suppEiTRbgV0dIEyviuV243/Rp6LSHnE80m/aedbT+Ct7+05TTZRJo2ov57lLNkMnnxM
         BUKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTj4NT2iZAL3WMyUQQXWU7mZCz87oWUFJChYyEg92bstZ6guoH+c/Kht4itrgfbNtzDCOc8ImogCPIHLt+xA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzHwsBfpY+w/YR7oWNwU2qgoNqPSOgpeGI0V6buC4/AJAQRp4OA
	5+8I2S+yZHb+ZhobKNVf/OfVMg/56J67pIbPkA8SPXBI+nw+uFnZ8x+nRhanK72gryXKr4JMASP
	B0QKV2ihJyABQUholXOJpp3S9Dw9zQD1j8kEa5KVaEW4dwVxrf90H3b8=
X-Google-Smtp-Source: AGHT+IETgmbKGfd1xQU1cNeTCGxYK4hEy9D7puCsVhHZDIL+YBWEIfAI3bvh3X6rLt+nen8YK2T8D9jziAfaY+Fbi57sg7sZE3cR
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:20c9:b0:3a7:955e:1cc5 with SMTP id
 e9e14a558f8ab-3c2d1b9bad6mr86207775ab.1.1734834662000; Sat, 21 Dec 2024
 18:31:02 -0800 (PST)
Date: Sat, 21 Dec 2024 18:31:01 -0800
In-Reply-To: <00000000000047b2a506189dfc1a@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <676779e5.050a0220.25abdd.0135.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bch2_trans_put
From: syzbot <syzbot+291aef749c5cbb9ca2fd@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit bcf77a05fb3d6210026483703bcacb22ed961c99
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Fri Nov 8 05:25:18 2024 +0000

    bcachefs: Fix hidden btree errors when reading roots

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=175672df980000
start commit:   e9b8ffafd20a Merge tag 'usb-6.13-rc4' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=14d672df980000
console output: https://syzkaller.appspot.com/x/log.txt?x=10d672df980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1234f097ee657d8b
dashboard link: https://syzkaller.appspot.com/bug?extid=291aef749c5cbb9ca2fd
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=10246f30580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=176540c4580000

Reported-by: syzbot+291aef749c5cbb9ca2fd@syzkaller.appspotmail.com
Fixes: bcf77a05fb3d ("bcachefs: Fix hidden btree errors when reading roots")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
