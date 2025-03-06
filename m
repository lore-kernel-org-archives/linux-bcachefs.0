Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0B7025A62B
	for <linux-bcachefs@vger.kernel.org>; Thu,  6 Mar 2025 17:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741280944; cv=none; b=SapcNffcuaVaIx5S81+ThW94eSSmKSmj71E5e/0a7x4GUCAZdw6T/sIsqjEOY1wLYjLhyGsKmH4zG71gisWPGBSHh41LDHliKUyCBuwiFQVadAmNvzx9x5bpul23vRhsPqSnSWtSrI3F+CuRDoikr33tolZiloNjWHc+Lq8MXb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741280944; c=relaxed/simple;
	bh=0S+1lCQx1kTZA4bG5Gj5ODnY9L3DS+L6keI8KNBTmSg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=QnzRzYYnB5L7mkx8LoZX+AWMPhlkFj0BoerKEUhL2X09hPtEHvLniuzyq/0IvpBNYfGFOYhPcMYfjVwQ5xhPhwf8Z/NMdGoodTkzb8S2vatQAXD2ZqHjFqQlhPD4TAUL3MPlK/FAbFr2BSmSoNwbbQPIEMuEe5q69tUlIcphzUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d2a379bbf0so15955275ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 06 Mar 2025 09:09:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741280942; x=1741885742;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=X4nLQSw420ybtW2kRIdx22c3Jume3TqtRHI8enXJf+U=;
        b=XSIqipPi/ENYIkBVclmfdAf2TM0bzG3b2URPAWl9BiSlKM0ztb7oYeVectkmFUvtn8
         cKFIgktoMJKmv8r0sjbtRKAXiWU/i40MBT/gwyx/pHsT2+TOh+UO9MmZO9FheEjzcPJ6
         Kk9b7qPSI673lMtWUSNDFuHYyyqSTAPeuDyVw8AsS2cGRhJBMIPZ4l/atzgZSHimxYah
         GmIBPzt7ZMvcPUW4H4h1erdbahqVRL3vxbZYaOy6IiPhN0tPqchoQcgymkPHTy6GM1m6
         afJ7MrOQUEYmwhB963pZbgr/gQufa3ixk8vE/xECn0sO+s1k7Fg/pVwqTe4dnp4lD3iK
         oelg==
X-Forwarded-Encrypted: i=1; AJvYcCWUxEagoq8/2v6LSjBv4spYAg5Us8mSyMdUsVxyaPdE9eWZqoOI8ttGypaaRaUAsMd7FSZaBVuNIupp13WKHw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyDwcaQvWRnDz8k1iEu+MbFbASZCnLOKCO4VBxj6LNjXuQT6tJC
	lMFX0BdnT2wWY7+1n2EG7NZXmse6z4TS+PBAmZZQRiHle6g40YH6sviE7H2o/sxT2mkMOg9pzHe
	Zfp6Q/y7cVolmlaeLRs44KvNfYagPcTMsa+YMfmlnk0BVGUuXsOZ4ABA=
X-Google-Smtp-Source: AGHT+IFSlWmY7RBkXfYTHzez26gr6XDSYt6SfsTmGP6W7py0kz6AjDNq7sw0S4nAJBjatKuGiYVt1jXM0SDBO0SDA13G1X6sS3jC
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:219c:b0:3d0:4c9c:965f with SMTP id
 e9e14a558f8ab-3d441a13ademr3387865ab.20.1741280941982; Thu, 06 Mar 2025
 09:09:01 -0800 (PST)
Date: Thu, 06 Mar 2025 09:09:01 -0800
In-Reply-To: <674db1c7.050a0220.ad585.0051.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67c9d6ad.050a0220.15b4b9.0039.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] INFO: task hung in vfs_unlink (5)
From: syzbot <syzbot+6983c03a6a28616e362f@syzkaller.appspotmail.com>
To: Yuezhang.Mo@sony.com, andy.wu@sony.com, bp@alien8.de, brauner@kernel.org, 
	dave.hansen@linux.intel.com, hpa@zytor.com, jack@suse.cz, 
	kent.overstreet@linux.dev, linkinjeon@kernel.org, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, mingo@redhat.com, sj1557.seo@samsung.com, 
	syzkaller-bugs@googlegroups.com, tglx@linutronix.de, viro@zeniv.linux.org.uk, 
	wataru.aoyama@sony.com, x86@kernel.org, yuezhang.mo@sony.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit f55c096f62f100aa9f5f48d86e1b6846ecbd67e7
Author: Yuezhang Mo <Yuezhang.Mo@sony.com>
Date:   Tue May 30 09:35:00 2023 +0000

    exfat: do not zero the extended part

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1356fda8580000
start commit:   bb2281fb05e5 Merge tag 'x86_microcode_for_v6.14_rc6' of gi..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=10d6fda8580000
console output: https://syzkaller.appspot.com/x/log.txt?x=1756fda8580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=523d3ff8e053340a
dashboard link: https://syzkaller.appspot.com/bug?extid=6983c03a6a28616e362f
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12cf7078580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=10197da8580000

Reported-by: syzbot+6983c03a6a28616e362f@syzkaller.appspotmail.com
Fixes: f55c096f62f1 ("exfat: do not zero the extended part")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
