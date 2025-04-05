Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269A020322
	for <linux-bcachefs@vger.kernel.org>; Sat,  5 Apr 2025 20:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743885424; cv=none; b=KvzPv7okC7PVc90hFMZcgMYZrK59FqKhyuKO7xnSIY6VWGBtsg+0WEt8n/AbWT9GRuUl+bI1kmXgtlcHPWN+j7kp5SPUd88MJuTn0bLJEwAdCPsVb2SzOKJsv951yzKlhTNkUcVK/dfMUJawPl/MGF5g60DS97CGIY/isp9nHX0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743885424; c=relaxed/simple;
	bh=zMlGhzgFbrY+JgytX4DSew8HdhGgXgAXG3V2s6Em6EM=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WpE3X8l5aQL7qsbkkwek+SlFsptFPX4sRpjxqSxkONjxRSy+R6kh79J2ajTtqTxFvphllskDvzPcqJUpNTY8H/8CTp+yE5g+dfGzJpjll+jn6PNizpYJpgm9XeSMei2rjsn3mzQVNGBvdI3Xl4dL68eP3W38OWr5f3mOX1Bjlzs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3d4578fbaf4so63186365ab.0
        for <linux-bcachefs@vger.kernel.org>; Sat, 05 Apr 2025 13:37:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743885422; x=1744490222;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=lq0z+umsMa3af9r59F6XIYQZFJYrSAW7N+r8MIuKdAA=;
        b=R4Kq71JJ0//8F53eS2EkPHX9Gtpuu7IhKpBll0lFSERXk4ArINgm02/cc0duQY1Z9S
         67C1FtlEg0GnQTddPrXwuU6mqKMZDNoJjhFkWLfAf5Lf+VqWyn33IDsT9I8VXlNuO+jP
         F+lTRd+HDAmYpWwGqxkbZQ7Nz/WaZ1+Vim8HuvW7Cce/a/bjBDLgq4OrG673ahcun51I
         cr8iSOOk+n2hM8qEmEtbA2S4puHL8MkCIfC80Cc+dHs4WCAzgmIn+0MSzPAlTrODQgiX
         QgC+KWGfoVPMfehsCTww+FNEQ13i2G7HH8UzLu0y1ziFXX2SDbrB48JevcW7t9+kLQqv
         wkyg==
X-Forwarded-Encrypted: i=1; AJvYcCWeseuCrFkkuM+RgEQL0oeGmpTND2XMn4IEroPwzlj+zWb5cgFSeVMntnwBBfzDAy2R50AqbysJLuWp1oWcug==@vger.kernel.org
X-Gm-Message-State: AOJu0YxLHXAVcS1BfSR46O3QP6Fj9Dj4G5v6QW9nal5J5PEjMR0vPpOS
	JyNP8XXhbbBCeBoDITQjuMaKp2n2bWGTBgUYGA5ZXzeQQM8kwQsPrfIcahSiH3yXzMLkuDw61K/
	Awfyyt2eeTvQSbHTLsc3sqPV2BxXGpO5idBmhLKX5p8gnz5cKAlLXCDU=
X-Google-Smtp-Source: AGHT+IFvSmJDsxHAwQYwXiAQnd+JyWMem4t0sD8xvT9TVS+OdfxxwESWuFt2rpSClIIsw4UVMiYD2fBoy9yBKty1smk2JpYpCtcw
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4401:20b0:3d4:38a4:388e with SMTP id
 e9e14a558f8ab-3d6e52ee9c1mr58296805ab.1.1743885422287; Sat, 05 Apr 2025
 13:37:02 -0700 (PDT)
Date: Sat, 05 Apr 2025 13:37:02 -0700
In-Reply-To: <ic4vadw4umsgdkx7mopnq2gxf33eoglf3ln6kfs4n7kihr6jz3@zmq2iyakast4>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f1946e.050a0220.0a13.024a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] KASAN: slab-use-after-free Read in bchfs_read
From: syzbot <syzbot+2deb10b8dc9aae6fab67@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot has tested the proposed patch but the reproducer is still triggering an issue:
unregister_netdevice: waiting for DEV to become free

unregister_netdevice: waiting for batadv0 to become free. Usage count = 3


Tested on:

commit:         56f94452 Merge tag 'input-for-v6.15-rc0' of git://git...
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=1299e23f980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=695196aa2bd08d99
dashboard link: https://syzkaller.appspot.com/bug?extid=2deb10b8dc9aae6fab67
compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
patch:          https://syzkaller.appspot.com/x/patch.diff?x=16d32b4c580000

