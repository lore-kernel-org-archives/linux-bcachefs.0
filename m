Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DC61442E3
	for <linux-bcachefs@vger.kernel.org>; Tue,  4 Jun 2024 11:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717500364; cv=none; b=XXGykkiSJb5tNlLDCq4oh4qgIF4azTjIoNawlmYLYfwxz8Ef33SX2UTf+a06ROl6RMltALj18XfIHHK/5Af7KPkGFddc8Kkcaslry1o9uffmJVgXcuSkwR/rP0eagB5q114mWrOMz7pSQAWCYxkJ7Wqxz1PRu5bKpxRM/m8d3Hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717500364; c=relaxed/simple;
	bh=GRpZtExmKZkFFuBkT38w2ZzBsG54iEBNWsQimsUe2yI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=qiJ0IwbZH5taBTkLBVQYBmenT8hxisXFWaf6m8qWnPOxigmSta9foBCB4oIv6LcWgSlF3ZjGW1jBlIMPG2oV680t0JkcvtKDlkIMPqccuo1lSqIa0p4S4ryEE1spJx5cmD/yp3ElnRv4w22XdRWVKEskWp+hvLQulGPvfM7oMb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-7eafdb25dbbso99600839f.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 04 Jun 2024 04:26:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717500362; x=1718105162;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aDWs8Qf6oC8uzuae/Q/CxGzelgua/8H3R+rkuuIVFeY=;
        b=W9gPt1Qi5Wh7jHH73V2sIujxrBrBETsEe7H8VmZps8u+llyFLNmTgKNlKGZDYRoE1R
         2g10zkiNEcTdoLsn3cTQmbBKHRk13+6WoMmp3dddFXBQcEoGWRf6LtaMbIfqvMEiJw6o
         YQD48CkILE06+5YuLt12/pqWzNOuF8LOoy3BzHzfLhSFhK7TSSTY3H97PhaFPz3pojlu
         6AEGqd8QIV/qLepTmchhO60MK2NabYuzKHH3CjXeDeDQfi3Z/65mho8aWzbRyAFgFDhE
         CeEt8ixd3HsnwkpGsVut10iLkYFrFKPjm/9cf9lUfLkcYTHFRLryFUAgOqM7yxoonP92
         86UQ==
X-Forwarded-Encrypted: i=1; AJvYcCVpIhYXo2MKvAOAC/QwR08uy/2LOI8x9EqVbLnsMxWfCwYX/NMY8CrY8Y8Qu7R3s3QNSMDUF2LbUYEMajdJMX0zKER8c6lsWX31k/P0bXk=
X-Gm-Message-State: AOJu0YxzfIcA7Qe2bJ1fTYdb1YI/MwczWOIalyYlIh+eqhgmbqBA0a8T
	bm4UPSWVLxO3CdknNKRJKMcETnIv74OATaTmNgpN4DY8mVeix4ShjdGSmzIXHgCFcp6jyFIDyFW
	Z7c20Ftw7EMWmYA7xZ06OfAZciV/PxIJoa20RrqquCNEf0BqEz+3w3XY=
X-Google-Smtp-Source: AGHT+IFqjayrCHItg5/UFPa9My7gZ+vTAstDursZj5wFpPAiNxTgpNaNTd6nnx4LypkdJBWeZEL2bJGFuJXvEXIUiSgKTiFpzhMA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:871e:b0:488:75e3:f3ce with SMTP id
 8926c6da1cb9f-4b53e35e64fmr296451173.0.1717500362096; Tue, 04 Jun 2024
 04:26:02 -0700 (PDT)
Date: Tue, 04 Jun 2024 04:26:02 -0700
In-Reply-To: <000000000000e9b6ff0618356b26@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fc10a4061a0eb684@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only_work
From: syzbot <syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1526df2c980000
start commit:   f06ce441457d Merge tag 'loongarch-fixes-6.10-1' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1726df2c980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1326df2c980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=eb72437243175f22
dashboard link: https://syzkaller.appspot.com/bug?extid=8996d8f176cf946ef641
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=164255f2980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16174432980000

Reported-by: syzbot+8996d8f176cf946ef641@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
