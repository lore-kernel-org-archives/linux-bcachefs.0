Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D073125C0
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 13:17:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716988626; cv=none; b=r+Trki1AY+8nlSHTBuS4TUFpWjjDuNk0SZbSElW9E3uwbhzNI4y17+kHY1CiBFMcwdmilpFxyJ4VIVbo+AuiTK8m501VCeXB2vU3jehcqAPeiBIzMxHzQvkXx05ZQOdQsdqtiQUsRgBykFbJegQ+NoH2gyflu0dWYS6ohhsfUZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716988626; c=relaxed/simple;
	bh=mHkHq3jMKH06n9vgAf2jzhRfI22gJrW6gclhd19+eaU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=WA85KxhzXDEa7j6jHbc9y4Z5wQ5TRypa4eFdGDAP3iRelKkwf30FLVW2IoPeiBuX2G8NhtIbbtBavtQPkq1kd58Ue6WyovnDNM7DbNa0Zpqz8YU5luQRxuYJfTDpEAMvBIuiFSbsNwVwHQl3o0vzn48DltE1sGweZYUZFfbRevM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-37387e56a6fso19134145ab.0
        for <linux-bcachefs@vger.kernel.org>; Wed, 29 May 2024 06:17:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716988624; x=1717593424;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qfO/SB2UFfHt97a87aSQyblLMjrNQ0YH7sS6OSZhUIE=;
        b=JVUD6/9X4WU/wkLxvb4dXX5l3uK1Y6sEK0FQOb0ecXZ2a2xNEnpfAe1Z6OrCu9Z7hc
         MBXEcICL5Qh6obWv0IDeCwshFqO2Y4XVFKFKsD11D+3xYJn2S50a1NrMF2OKqnn6RK9H
         fcCEqNHEAnQTDeibATyVrVxtA0W79fBrGvImCLnYLKER0dAVXUVB7pKSr27wKBEiK/uH
         VjnA5sgz15jwzPFWrgbnLxglObyTdfChv1cZV+bxCQRxmkG8DzFO8gN/fFJzDyCrF7DR
         P8wSQCX/GTQ50GNnex0FfSlyBA+Dap8NfGTYboyjCk1+P8b81uen9elJa5QmTrOor3NW
         IS/g==
X-Forwarded-Encrypted: i=1; AJvYcCU4kbgRV74JBSbDImG075dsGpfSNW08rvDsoDM+5GrKj8EGlxGSsaLNmxZx9ehHaMDN7ALLcQlfznTkNGSTUO6iSrTOegsbt7DkYrfxVCU=
X-Gm-Message-State: AOJu0YxjSvAnEsA79LCY1FqPOJgX4zKdjQWISjnreEiwnVtJWOMxa/l5
	bCAAon0oQvzdY+bjHDarPaifWU2Xa4950kvMevCFlalaWzty1P/BNzFPr0XfLuiSCho1z11MWwh
	6tpDXgOdyhFpf0nlFX432+Wi49JlsUGIEiRem0Bh6xWXIG2G4faoHo+k=
X-Google-Smtp-Source: AGHT+IH69uuYJoSGUbkjmQu3luLjcHAK2G1MSD5e3SByJKKkardLk9TaBJEgPDSfC7inxTgZ8mfcbypAYmshT3hu8NG6Y+ek5OgY
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a92:cda6:0:b0:374:5d81:9136 with SMTP id
 e9e14a558f8ab-3745d8193d4mr4771605ab.0.1716988624612; Wed, 29 May 2024
 06:17:04 -0700 (PDT)
Date: Wed, 29 May 2024 06:17:04 -0700
In-Reply-To: <000000000000849b0606179c33b7@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <0000000000000dc0d10619979126@google.com>
Subject: Re: [syzbot] [bcachefs?] WARNING in bchfs_truncate
From: syzbot <syzbot+247ac87eabcb1f8fa990@syzkaller.appspotmail.com>
To: bfoster@redhat.com, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit 03ef80b469d5d83530ce1ce15be78a40e5300f9b
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Sep 23 22:41:51 2023 +0000

    bcachefs: Ignore unknown mount options

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=1077cf8a980000
start commit:   b6394d6f7159 Merge tag 'pull-misc' of git://git.kernel.org..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=1277cf8a980000
console output: https://syzkaller.appspot.com/x/log.txt?x=1477cf8a980000
kernel config:  https://syzkaller.appspot.com/x/.config?x=713476114e57eef3
dashboard link: https://syzkaller.appspot.com/bug?extid=247ac87eabcb1f8fa990
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=15c61a0c980000

Reported-by: syzbot+247ac87eabcb1f8fa990@syzkaller.appspotmail.com
Fixes: 03ef80b469d5 ("bcachefs: Ignore unknown mount options")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
