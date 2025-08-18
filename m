Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5082765C9
	for <linux-bcachefs@vger.kernel.org>; Mon, 18 Aug 2025 10:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755513665; cv=none; b=m40LIYC/o+5RzeauQA/cbfkNI1qs9+5WVxmMVPaKAPbwVhkC0nfCOO1mIQ5PAbgh8RHYsvsMaPlfJ8/TiNDIy9SzcVF4v7iCd3gxkLxYqYr1wMBUCRjGwfdET54Ccy0ysEbX/xHWFGCBQ3HfPlcVg0N+aqXrk+OXGewCJn0wAH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755513665; c=relaxed/simple;
	bh=Mqo3UGE1Bme+tAtLCwb1TjVSd0SAvNdv83hNNSqLSRo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=e227QFYLb9eGj1Qz+r3iKLc2GC/R5rQ2Cvf+1Zcdzz3yJxcAYRQsLxC47LvDMQLlJiU5EH9rmIIErZlat78C/3FJFFDdKY3iYKsQ/CwWB2WQmcs+RiKUn59wKr46bwd9xMsUiJCZ+RufH6wbJboBR/QmBrHtzIw1NAaHT7GBWkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3e66b7e4a94so29903635ab.1
        for <linux-bcachefs@vger.kernel.org>; Mon, 18 Aug 2025 03:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755513663; x=1756118463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NrG4Vx3qtfYQeDvjaRE/m7vDhTfLYlJ5GgLEgzLgGuM=;
        b=WYtRQoEFzw7WntpTXzvsWrrWp+77lHkPWaBLklw8tv/abX6cYwti6UbdhDkjZpNOA4
         IFS1PcWQLWpuwQSg9tPL5MaXBNoJIzB9UOdVhYdXJdBs4CRMM2u1SenT2R/JIHSj0MT2
         F9XOCHeb1VVM/6YnUqTKUFnW4dSHHzzTlGahq1h8FV3Vq5B/cf+6Upkbs6czAiiMcJ17
         qj5vnR61dnM1vtPrkIWozbFT1h6QphhoFCSKY2IYIAX9CBe/MbGsL9F/Dz7HSOOtJNJU
         7QRSPk7WUBZo35jzwt3/KdlFCCl+sQMINKgcmtel9M/5nMseMzxb/VpEPmheycQd0DK7
         IIgw==
X-Forwarded-Encrypted: i=1; AJvYcCU76AQxvnOpAd4WOdg7x0bwwkFFuyfKXPiuawnMWDvB1ZxostXkAtIkdP3X+eLjWeZac4E/pQ43JoZpEfVDIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzodOZaCjWIwcBJa9vVbK1oGrGGQx8QVk6570KE6cUmuQITuhva
	EcmalQyqBEzWyuRBx4InEsqlJlxCKcvjGkGTL67/j0FUpdRkzpyLVpcdxxqHF39ta5jCaF6OU3h
	mE+Ng91JlCdc5t45AJvVIrjkat2SSQigpZcPUBnpiQhKep3gZSmiNzSVbLbU=
X-Google-Smtp-Source: AGHT+IHfdTrRhdyZ3XB6wJijBqmptBu3DqMxOJvCyZB34vSwaAse6RzFijYi6lrsi/1vwFX0auHyhwvXsWtaLfATYZ17mRqpsOtE
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ca07:0:b0:3e5:5937:e576 with SMTP id
 e9e14a558f8ab-3e583804f82mr160391565ab.13.1755513663154; Mon, 18 Aug 2025
 03:41:03 -0700 (PDT)
Date: Mon, 18 Aug 2025 03:41:03 -0700
In-Reply-To: <CAOQ4uxiPPb70mx0Pr4Ph6hw2j63Q8=PZaxBx3N0KP=d7Ko=1KQ@mail.gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a3033f.050a0220.e29e5.00a0.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] possible deadlock in bch2_symlink
From: syzbot <syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com>
To: amir73il@gmail.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-unionfs@vger.kernel.org, miklos@szeredi.hu, mmpgouride@gmail.com, 
	syzkaller-bugs@googlegroups.com, viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch and the reproducer did not trigger any issue:

Reported-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com
Tested-by: syzbot+7836a68852a10ec3d790@syzkaller.appspotmail.com

Tested on:

commit:         9e7e7e36 ovl: use I_MUTEX_PARENT when locking parent i..
git tree:       https://github.com/amir73il/linux ovl-fixes
console output: https://syzkaller.appspot.com/x/log.txt?x=11d09ba2580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=41498776bd40da1
dashboard link: https://syzkaller.appspot.com/bug?extid=7836a68852a10ec3d790
compiler:       Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7

Note: no patches were applied.
Note: testing is done by a robot and is best-effort only.
