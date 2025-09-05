Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A73B8524F
	for <linux-bcachefs@vger.kernel.org>; Fri,  5 Sep 2025 22:54:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757112845; cv=none; b=IyUumMPK5FPqBAqMYO5xpI1C7pW44D5c+JZMclfp2TyRwryE4CbBe/2prQF/b2PUhunvcvO4H8dJy9ti+Ncc8JUUiFozkKEYCHUXZzbOS81J7ZVG1LhdadMsqtpRWGK9iDTUhEsAvn4LSl/WXFK3rVYFCZu8ARiIUIHXWqQ3c+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757112845; c=relaxed/simple;
	bh=xmt+7MUYLe/TsNdv+UTy27pUcBGcGqm6Q3U60XaPyoQ=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=EMHFTHpsEl7rmk98tvoFJD1GErH7OjbIAN/LJUEHAbEQFnFkftVCX+teSqrSt7oPcO/tWL3N95c99DiFUTDeTC2bRd74gGZ4WkTgaVNvrD+kCkmyuDfndD0SW3HmAI8J10XXJLaysDx4DDM1p0DSklb8P+7XtIv4xWbW67eGVkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8870345ac41so562243539f.0
        for <linux-bcachefs@vger.kernel.org>; Fri, 05 Sep 2025 15:54:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757112843; x=1757717643;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=COPuUn8LM+pX0RzcctilePF0Lz9RNH7VZuFaMlEVmdg=;
        b=fdzhV05qTILm6KtvrOW1VBzso5jHZtLWj792qwF6P21oQyN69mDVnOd59e8/EiPZ82
         pCxdrsRCafWRfcMcbWO+z/fBKj/8ypBiaYOKNQOvDC/EE2M6fjSqAl++A+CeXsazTQwn
         AgtHR9SkTfJpksLMbaSRtDMwypyo6VDL84xHxyadALJEdP3soZJyRcdw5/aC8gfRf/9q
         srwhNlQMqFmD8YLhnGV01zgsNN1IKpHEC3E+0UOPdi3jJch0THKGbda5RyNk4ch/C3xN
         wlTAd47kyNW6r9IKzapDXgxQ5M2HlZPiSvqSyR3NTXV2w+mnrqkPl6cVM++DLeEjjPTU
         c9Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWGUmbK3Acfn3JntC1DhhGw9Khi2jjpanGjLaZOkWWSOIT+KSy5pBMquWXqNyv3QnWlmirnbXuER1S+PrW5+Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy23JhFKIwHmJ96Mekh79nAP3B7QgyZPBowViAPHDAvk9ZO0Vq5
	ScZUYgeRKH77ZocnHlHSBLhRCS7+pc0U4axjt7eeU9pSka7awnvmfKkGjoGjngeL2rUjsFSy60k
	dqnnEw0Ck5kX+29Wt+Oo3Ya3z6PeT97Vb40f+J6k7TpLTrCPDuaqoN8o109Q=
X-Google-Smtp-Source: AGHT+IEHOamtQTp9ShtnVHZx0Qpq4+0a3CZAv0AdYvOBwovxa8eWaiFwDq5yJg/DbuolI2h+7rl1AdMtyIvqKAj+FgJsMR10oQyF
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3810:b0:3e5:4e4f:65df with SMTP id
 e9e14a558f8ab-3fd82163cbfmr10431275ab.9.1757112842915; Fri, 05 Sep 2025
 15:54:02 -0700 (PDT)
Date: Fri, 05 Sep 2025 15:54:02 -0700
In-Reply-To: <68bacb00.050a0220.192772.018c.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68bb6a0a.050a0220.192772.01a0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: use-after-free Read in bch2_prt_printf
From: syzbot <syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit c21f41f6905be4fc5059a10a5bba94105ba87269
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Thu Apr 24 21:55:20 2025 +0000

    bcachefs: bch2_dirent_to_text() shows casefolded dirents

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12c65312580000
start commit:   d69eb204c255 Merge tag 'net-6.17-rc5' of git://git.kernel...
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11c65312580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16c65312580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd9738e00c1bbfb4
dashboard link: https://syzkaller.appspot.com/bug?extid=7f176adb30b21606c5fc
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=178ec962580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10097162580000

Reported-by: syzbot+7f176adb30b21606c5fc@syzkaller.appspotmail.com
Fixes: c21f41f6905b ("bcachefs: bch2_dirent_to_text() shows casefolded dirents")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
