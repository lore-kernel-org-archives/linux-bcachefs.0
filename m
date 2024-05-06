Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9143E462
	for <linux-bcachefs@vger.kernel.org>; Mon,  6 May 2024 04:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714968965; cv=none; b=h4Cp7wC5lscWTAf4O46hGwWwZIB5FXb1kCHqjNqwOEgN3IvmBKURqGz7fZAfdRyynLTJtwD5H6csbXm/bRaz2eufJPi343lgPcpN6UzoB1NxIlr2X4gjV+cI6/GNMX7FgZbEDfOzt6GQAHJxqpUdNOcyGg/eJmMBzJniIEhTZEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714968965; c=relaxed/simple;
	bh=e7d3eUevSjyBi1+UMir/tIUoeUJ0gThJDxFrmjgtjFM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=cU6cG+BWo7cWI6ZsVE2jKwWFy02DquEnna6QT5vxCl6GimXLnqp8cFHPzkrlx2PH5kuQyJbC/S8/vHt0ERAbpdPHX96kPgW5/bxI9bkSPiKNX6sqlPBzSZXinTFTlUJjoV8j3y0HSrDKcTHUsTIHRe8stTN9o7pt/fbK6y71qhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-7dec58efbfaso197965339f.3
        for <linux-bcachefs@vger.kernel.org>; Sun, 05 May 2024 21:16:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714968963; x=1715573763;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=E6sYdOPnTbd11s8yXYICIhsmoL2HnQkl/tBOTzLZOD8=;
        b=Y1CPfTWE8ehgO9R959LBYoTzphic2f5jBtpbuSXyOxEdfd4iJI6xIt+M8M1q35zFd3
         X3M9kEbkYfB/Hh4yo+J+w6Vs2aCEtYRZdi4NbQbUAyc6H4aTPeiZ6eWfhl3fTnWiXXFo
         F5Vb0Z22TbD7LHYh2noW3/Khnzpi2cUHUwoh4zubp7pMSgXlHCHL+yjkKg9kfylsfumn
         Xs1aTXxn/57FdehuRW7cdKBK9Tot5BhqXYFeLweXim0R3WCkjsJuK8Kbo/P8MCBhMdsf
         aB5m1M4+5Ph8dkjWWF1llGGRbSIDKwuAlzJOP098Z6blFeeCZHhd5zRBOdW8rEbjTDaL
         sX2A==
X-Forwarded-Encrypted: i=1; AJvYcCXXxVAqphv5b0NMbpANBm7W78wTqJl393Lph3sBR7T/312G68g/k7K2l8kpeb9A1yyJvfEKddh1RMIWULgY/1N1l5sEOHzvJzV6WuE3yzE=
X-Gm-Message-State: AOJu0YxGR/bOEPDpQOYMA4KrTAjFV748zvtRPaj0Wgk5xlAZW848H392
	u0+xzxjx4OSMItkzJzZ8RiAu8klcUADnRFwjzQVwjOOs1RpWSeh3O71Azv2wdKMdtSy1CeBdRAW
	KVl2wMbgSEQDrQlBx4Y4AJuGpw+QX3UUoxDtIZoN2cgbsmhlLMcIpQkA=
X-Google-Smtp-Source: AGHT+IGBk4Y+VQkB5ysWua6toZHslQvpRpftX5qlHvumtyLVnI52zH0H+bBch9oaAmKS7e+ZtCr14q2TWHBub43ps5U79ZwBI6at
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6638:3e8e:b0:488:5ae4:735c with SMTP id
 ch14-20020a0566383e8e00b004885ae4735cmr440652jab.2.1714968963314; Sun, 05 May
 2024 21:16:03 -0700 (PDT)
Date: Sun, 05 May 2024 21:16:03 -0700
In-Reply-To: <000000000000918c290617b914ba@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000dc06ed0617c153e4@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-out-of-bounds Read in bch2_sb_clean_to_text
From: syzbot <syzbot+c48865e11e7e893ec4ab@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=15e58a70980000
start commit:   7367539ad4b0 Merge tag 'cxl-fixes-6.9-rc7' of git://git.ke..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=17e58a70980000
console output: https://syzkaller.appspot.com/x/log.txt?x=13e58a70980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=d2f00edef461175
dashboard link: https://syzkaller.appspot.com/bug?extid=c48865e11e7e893ec4ab
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1043897f180000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=145c078b180000

Reported-by: syzbot+c48865e11e7e893ec4ab@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
