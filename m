Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EB141EB1AF
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Apr 2025 16:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744301406; cv=none; b=OPJ+VwKlzqK89yaX0LSMP5xGzxmkPoxk3UJGLKNOpvMZYg2IkYg+qEE6GqeSM1qNo1JdG1BIbeFdOeWdV4jjaD1xjthd+xtxuaEU+lukHTqe3oFpFRPBGZOtO4QvPOQ+nQ1SDamxkQ+ElF5LkgEU6GIb+3jm65330Dv0nPR+h00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744301406; c=relaxed/simple;
	bh=uLCUDYBiKGmNNahQ8ulWRPQAlAHtkv26eGrpFarofys=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=XV93WiT38p0mCAnjvZWRRAL4JyT4AbvTItK8koM7eT0IDQrVWKRuFOVpfCsvU1qR+9ZuB6s60gdeZlj9XXMJiVxVy0MUL3ieaIWB2gtaqUAfAfclLGekhNK1vLo96URkU1HEXFNx31Ww6476CKqtMUyA6FViYak2RC7D35vgERY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3d44b221f0dso17584025ab.1
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Apr 2025 09:10:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744301403; x=1744906203;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JYNaIvH1kPvnW+M8OBqXOeFieDfcqbCw9nZalfSL0ro=;
        b=qsa8oVeyQw+rv01W1G/HMY8oS+wBsziA/nnjqULZKg4Iwa6kXEyDN3Q1NTRebJ/i3R
         NWSi87rB+a72EynWxrOfJmixAUYwRaG2pGnVGrvoWIuxXO9CyCyWvLA0kLJKWcY9Yas2
         cmJJ/dK2iv2U6Dd7iPOKbEwdp3TayvpxGxXlazOMyz8BoUc01lDsRd7I+4sqPpzg9Ndq
         /crzzgIoZNDazB5IDtriSnO4gfUkMg7lLZW6qTjaDLqAAYBdKMy3WPOL2frwJMaZtdas
         ooRm3m23XRr9wcdmnhzm6VocHwDz3u3OrqJy/wuHscPEVFNASeyobRrDX/ZDmYtC0e92
         80GQ==
X-Forwarded-Encrypted: i=1; AJvYcCUk12tmRQx8QmPMHPPPAjqRfbTLQk5he5XoV4I08mF2wE6MuYkqoGk7qlXTHYFspVQedmCWklgXa/Wl17IryQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwoGEPzIvGgrmTX1qOIvwD/RNB6eyDZEW1+OnViguPKd7ypE9qx
	IN2N8EmPsaTY/KGyLyyFu+T/kxfTxNyF6ykg4G5GjIwek/ix1dZacDKM9aam+EOxWen4fcRtDvw
	8abZNU3IaPTX108Zj7AQ1DmbHP9yue/MAA0Q0M2gVOc4X19m6OKsoTnw=
X-Google-Smtp-Source: AGHT+IGxPINkI9sv+/7WMAqe4TkBJydLJlvsPCmCOtDcmdkoNbAAzmlrLUfhGBZJIdTaW1ZiCdXy/nGHmdGLZPfustLZQVWAXQ9L
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1908:b0:3d1:92fc:fb45 with SMTP id
 e9e14a558f8ab-3d7e5f4f5d3mr26036345ab.5.1744301403717; Thu, 10 Apr 2025
 09:10:03 -0700 (PDT)
Date: Thu, 10 Apr 2025 09:10:03 -0700
In-Reply-To: <674083af.050a0220.3c9d61.0190.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <67f7ed5b.050a0220.355867.0006.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in qlist_free_all
From: syzbot <syzbot+86b24455266617775c21@syzkaller.appspotmail.com>
To: bp@alien8.de, dave.hansen@linux.intel.com, hpa@zytor.com, 
	kent.overstreet@linux.dev, linux-bcachefs@vger.kernel.org, 
	linux-kernel@vger.kernel.org, luto@kernel.org, mingo@redhat.com, 
	mmpgouride@gmail.com, peterz@infradead.org, syzkaller-bugs@googlegroups.com, 
	tglx@linutronix.de, x86@kernel.org
Content-Type: text/plain; charset="UTF-8"

syzbot suspects this issue was fixed by commit:

commit 3a04334d6282d08fbdd6201e374db17d31927ba3
Author: Alan Huang <mmpgouride@gmail.com>
Date:   Fri Mar 7 16:58:27 2025 +0000

    bcachefs: Fix b->written overflow

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=102a9d78580000
start commit:   69b8923f5003 Merge tag 'for-linus-6.14-ofs4' of git://git...
git tree:       upstream
kernel config:  https://syzkaller.appspot.com/x/.config?x=57ab43c279fa614d
dashboard link: https://syzkaller.appspot.com/bug?extid=86b24455266617775c21
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=14034b24580000

If the result looks correct, please mark the issue as fixed by replying with:

#syz fix: bcachefs: Fix b->written overflow

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
