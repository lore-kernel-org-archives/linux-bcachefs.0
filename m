Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64076243399
	for <linux-bcachefs@vger.kernel.org>; Fri,  1 Aug 2025 11:19:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754047146; cv=none; b=KarqlMft+sdGdSKUOBRoVzkb7MWYtIUvIfHaMmHTEXMm9njZmRNaIMFsv0SoWVE0CPPUpg8jgkkdlaKQ5naqUYTrdl+F5ZFSVpEAxMbJfINE3/PW9YSkkXII5QO+EuoBXf8c32wyYempc817wRnqTXV9JubyY1kmp1DlmCsDGHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754047146; c=relaxed/simple;
	bh=q28JNh58dwBqtCM6swD3TmohMfXvSr3pGGkFR+t6hb4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=PJRhfKC/7+QxbLg8TBnAOC86suzsMDDDEIUlfX1W2cVwVRlKiTEW7bFZUZDi8po9q0nid4ZKCVaxPW35xlBzmlR0qWMB8TRPv9eTXQBoy78L96qSaY9dUevgVXDLzT2Bz19t9xEiy6FHuCXmeeNjmes6W96XiydEIXzN5ILXrHI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e3f75449b4so11549395ab.2
        for <linux-bcachefs@vger.kernel.org>; Fri, 01 Aug 2025 04:19:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754047143; x=1754651943;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9zQIgqfHRWskP84CROWGGd3zjZJ5REbJ6oo2IHFf5BU=;
        b=Ja1wjNMebOfP09Jj230s9JQSlb/HQdupKdKRiYfAOJqvfL69l1rb+nuo4+1fDO/eGm
         jRWX0J8ZSHck8hhkpZR3VHZCOMw2VOAlL94JUn5N5yckon/TcAh3W3fuCGTw9iCbn9wA
         pV/TDgwqiz68HnoW7nyGUhYRlKpUi/3tggN4oPmlqG9QYRShEtYsCcUzkimOchPKpVsS
         73WHVtkSPs8PVe/D6+3YqTOJWmgXcXETaxivejdKwRTkM5IlFAdSyPcfLDjLNS7x4cyI
         IroVCK3EoF+qy97/TpKBQ0glqeoIuhnEDBPXtSgbQ6kYLXMDBarBjCx/Bz4NZ5tR32fw
         br5Q==
X-Forwarded-Encrypted: i=1; AJvYcCVGDRpyiSYttrhEDkchYJmknP+pQsKBjo8FV9t11p9+CjKiNgskqr6FFXrN3Q34Gv/N5/Q4WACzJytJyfzALA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5E87XUZsfuhu/KtYeMpzIqrxtIoJntzwYdhnJh3BUINtWQ5VK
	NOixWIgslxc3Qot7ux68DYIouCJacyOJhACyP555yli6sMYG8AqSkWsV3MvChRtG+KtngljduIX
	l2h/vYpOmr1NNebIVoOwsx7/Z7LypD7PIo4F68+lK9VJMTLUWwihRBztWBYo=
X-Google-Smtp-Source: AGHT+IFhhBqr8M8cc4DELb56FmCE9ort3fOeUhYgkgxclllTiA5Y40kRdwhPkZMhAC1T1qYw70mCHH22jwMHgGhy494ttoB9yXMb
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:ccc2:0:b0:3e3:d8af:3847 with SMTP id
 e9e14a558f8ab-3e3f6280e8amr145442905ab.16.1754047143387; Fri, 01 Aug 2025
 04:19:03 -0700 (PDT)
Date: Fri, 01 Aug 2025 04:19:03 -0700
In-Reply-To: <688b3341.a00a0220.26d0e1.003b.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <688ca2a7.a00a0220.26d0e1.006a.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_repair_topology_recurse
From: syzbot <syzbot+9eb4c69fd4d4a1934f3a@syzkaller.appspotmail.com>
To: kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit c366b1672d74cb008974f6e36e34dc191621f3bb
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Apr 26 13:31:23 2025 +0000

    bcachefs: btree_node_data_missing is now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12b59834580000
start commit:   e8d780dcd957 Merge tag 'slab-for-6.17' of git://git.kernel..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11b59834580000
console output: https://syzkaller.appspot.com/x/log.txt?x=16b59834580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=b45b5c69b7ae37ec
dashboard link: https://syzkaller.appspot.com/bug?extid=9eb4c69fd4d4a1934f3a
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16d2c834580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=11d32cf0580000

Reported-by: syzbot+9eb4c69fd4d4a1934f3a@syzkaller.appspotmail.com
Fixes: c366b1672d74 ("bcachefs: btree_node_data_missing is now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
