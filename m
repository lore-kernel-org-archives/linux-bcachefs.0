Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C5E7142634
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 May 2024 09:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714988166; cv=none; b=kl7c3I/vJ1qiOuUgfEHirxw/eGO2k8n24gdT9Xxg4+MpF4416WllxLnFY22ao6MAnL01Q9zlQGEaVM8wZxZ/bTiQ9bzHHT4uuoar3kWp1FoMrx/0Ge+m8DVHJ22loFGnbpCt6cZX9XVANMODMfEkyYAACJaCtaldJMGWCG6SUSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714988166; c=relaxed/simple;
	bh=AnhUQnMdGrRZOxXZdeozV6MOrXgYCXG31theF87blOg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=czfg8nCHTL/engccWJe/Y77DcjzvZEHWJue1c8ijBpPMcLPXSLd/2nM7zkhRHVoU9Ny6LFlJe+DZ5PZlOn1pck31ZG/LqZkF6Tmu1oW4++df2mhjL6H0HbpXjK15BR9hXgHQ6eTrFc8Ievx1fCIia0LURJqUpwDYKXK3QLfygBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7da41da873bso282761139f.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 06 May 2024 02:36:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714988164; x=1715592964;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zv5x6Nmy7t07YX+YnaK0VGIx5sNBuwgtq9Vcfuj51bA=;
        b=l3Z11MFSgkcpa5BDK+Df7u2zkkTZXDbgDLw8yiMgnIJdVTYI7J7OqqOFLnPRq4bKi2
         30ZtBEu4RdirFlaqu69VLhbgePZNY2XUddzB5oWBlq/REBSRfxYoB3b14Q/V/qwr26Ik
         JkuVG29Ka5NEL1tlT0BGrvInRrisg9VrwMv+C03EodzHUJ0yAjxmnoQTrtkggPYV19aH
         FKJNpI/cAJqzws58SOUFV3GOMFspum9eWCecsSjjI+s7yuCu5lnZ96vZMPEXktSA45/j
         L80yX+uuu7KnB3mdR+Dm2RcLHi9/3PZCA1yybx2/Yd/5PJh+FxfvTNTcQrY0FEwXLpev
         dNfA==
X-Forwarded-Encrypted: i=1; AJvYcCXUkdg9WeA4u6HCtgzb8egkO9F1dvgqlciasRniJlAMaJJGxtQMijJxjUZ3dJjYc8E19OLYy2dX/rhcv30hTvvKW43Uwg3vgmVKFzkUOcg=
X-Gm-Message-State: AOJu0YwOATbuZIcddxLCA3jB5Q2/VBtdNB1jfxjZ5PG1fq/hE4b1a1hI
	nWQ8fyFPlCnw0G2eNSMnwffWxto0i/Rqxjq9K+kXNENIE4BLG3TdQpjXVS54/N0qflfL3dWHEeS
	eux30tvejNahT0eG6PvXB2NflQLTvNEar0Esp2Tp/prfxXg9llk/hJWw=
X-Google-Smtp-Source: AGHT+IHO4idvgpUvaa9A/19lxtxEAU+Qg+pRM/VhI3hOV9Bck/gnw+u3jLIrwc8UwbOl8L8uFiEpCXGD2usdmZFcNGsYW9LgrsS7
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6414:b0:7da:6916:b435 with SMTP id
 gn20-20020a056602641400b007da6916b435mr353342iob.0.1714988164735; Mon, 06 May
 2024 02:36:04 -0700 (PDT)
Date: Mon, 06 May 2024 02:36:04 -0700
In-Reply-To: <0000000000005c46090617b917e7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000005a730f0617c5cc76@google.com>
Subject: Re: [syzbot] [bcachefs?] UBSAN: shift-out-of-bounds in __bch2_bkey_invalid
From: syzbot <syzbot+ae4dc916da3ce51f284f@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit d789e9a7d5e2799f4d5425b0b620210d2fcad529
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sun Apr 14 03:59:28 2024 +0000

    bcachefs: Interior known are required to have known key types

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1070e9df180000
start commit:   b9158815de52 Merge tag 'char-misc-6.9-rc7' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1270e9df180000
console output: https://syzkaller.appspot.com/x/log.txt?x=1470e9df180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=ae4dc916da3ce51f284f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=11a910c4980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=15490b54980000

Reported-by: syzbot+ae4dc916da3ce51f284f@syzkaller.appspotmail.com
Fixes: d789e9a7d5e2 ("bcachefs: Interior known are required to have known key types")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
