Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D22F0263F2B
	for <linux-bcachefs@vger.kernel.org>; Tue,  8 Apr 2025 08:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744101665; cv=none; b=D4PkXSYoPk5PcCvxP09GnRAceWFhrlZYGcraUlP//Ml/Tb1Ivgzu3b2WnmVT7b+zO8UVowMgKdHfVA6E1HUt4o3D02+j0yqgWP2YzaFsmoBYt0GLOUFA0jHw4ImGfOtyhNuwaEx/cCe+aScky59MYok5uHqYG4Jvae9gQXwSjyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744101665; c=relaxed/simple;
	bh=SlDbiuoYIedZstX15tQvYCFIOLJTh2teoyOwY4O2Fgw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QcIcjuMSQMguqAlStOnsVCZOu2OjOXfXNXmTVCTdtdQx+13ZPAGHo2dD1eFoDCwbX/i9VWz0MJiDpsRaoRZTujgLFw7OVSDONmyk32tMMnO4oK6UnRUSNAVpUh0ZAqEiIM+xS8YaULPmuXwS2DZnufmtHq8ZI+WPME3+OBDDTok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-3d43621bb7eso65182725ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 08 Apr 2025 01:41:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744101663; x=1744706463;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=DFxw0IIuBP5M906d9PbBpExGapOGcyT94nzv7ktzd3Y=;
        b=AUQRZ+pog4nuIHdLxVMbqXCL3+7FFriTmCrklh043FHKL+PAJrufONkoa67OFW33Xh
         IZh8y29Z0QD68X7/8+aoq52icbBoGEdslHpbwutxzkbWPtwWaAh7ElZZGrhtGDd2b++l
         XIZmdF9Pxh2rIDi+8OuPisLkg0XN+45aU9PKY6Nf9W16N6Zb3fZZp58JLHmBoDMygJf/
         BpYSXNlL2tHx2m2qnhqkzF9dffEFZbGDDKTrsiI1foSCBXQpf0olwWCqQiS1sUsk4FDm
         QIfHCmZFfrZSC0RwmDzdzDH8SdAAU1Z14JL5IWXhkh399XFWuZrl3akD+ytty2ioVXqT
         0OoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXWNilZFPr9cfdsnLpnfr1FKfpIF5GPvKsqgSoN/pauhxDd4vjNJoHrnFLR2cYIu7k3JuuhhMe/3uLKW6Rd2Q==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxnp+0zmNlSbzu9foPFgRJKTIZpxQvHN7pgwKB7tg1Y52QyY81C
	DOf7U4HZadrqbP/nU1qONv3E4p3aISjiA/INOe5U9zKVKa5ZWl4Z2xRFCsp1S46Tm75w+dT02yr
	53PrxCiUeCzKisJxD7RGQc5D/CLpZc1WKqwOUeLpe5nMHmOUHZ4C2/Fk=
X-Google-Smtp-Source: AGHT+IHCiaf971JXRLG0SAxxWGrKuZEYwiVkN3X0+LNLpVOTJeUT4Wz1k0EYEr/tmbmPBS+DDXdAUMajBQeBUwl7zrdjaj9v8hpx
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3288:b0:3d3:f72c:8fd8 with SMTP id
 e9e14a558f8ab-3d7036bce59mr26236625ab.6.1744101662937; Tue, 08 Apr 2025
 01:41:02 -0700 (PDT)
Date: Tue, 08 Apr 2025 01:41:02 -0700
In-Reply-To: <66f53709.050a0220.211276.0068.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f4e11e.050a0220.396535.055a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in bch2_fs_read_only
From: syzbot <syzbot+c7aacacf99dcfd3475a7@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 8b22abb4c84058e9533d71a4814e54316ba2621f
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Oct 12 02:53:09 2024 +0000

    bcachefs: -o norecovery now bails out of recovery earlier

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=106bd23f980000
start commit:   aa486552a110 Merge tag 'memblock-v6.12-rc1' of git://git.k..
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=bad8b2899350fd0b
dashboard link: https://syzkaller.appspot.com/bug?extid=c7aacacf99dcfd3475a7
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=102b699f980000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=151ccaa9980000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: -o norecovery now bails out of recovery earlier

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
