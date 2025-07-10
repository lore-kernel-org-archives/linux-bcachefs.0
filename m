Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B43628ECC0
	for <linux-bcachefs@vger.kernel.org>; Thu, 10 Jul 2025 16:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752165606; cv=none; b=B4Tbf0R6a2NrZAU+nY8boD0FarRuzbXJKDr0iKDJilzN63qiZn2qs3thYC+oOGGNrRMITih+iIqgwT+Vb5hDXYjeR/SqHH0viQLG1iH6k7p/YoyeuC+9MRs4Pc4XiGIMz9mVh97QdpFzX7w+PTy9BQRBq/F9kNnel7mlSWEVRzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752165606; c=relaxed/simple;
	bh=rXk8Ku8maymFXZQ1YWOlmFsrr2E35x3kFiN4vQXpIJ0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=Ei+0fH1We7W0Diforqc3h4uuW+3/DsPgVD7vocnUbj0VxDIeZs/1X5j29rnIdm90Az8EXpcpEytCd/B2k6bTp2w/CYjc6mO5et8FMqLq7mjUb+Y3UofpvFr4M7OtCotnud3jOo6ki/vf4oiFFdtncK8zBmtOSpC0AHvHaBfWqxg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ddc0a6d4bdso12127545ab.0
        for <linux-bcachefs@vger.kernel.org>; Thu, 10 Jul 2025 09:40:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752165604; x=1752770404;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FB7nCBC6Stvg7o8QO2/yWpTOea8ms+uU+NpYCaO5Xqs=;
        b=kuuUHdf3Y5L55c0XmNl4dMCEFRH86Zh2/fBrz2coYFfvVqiBCFsLtk//ZFtrrDXsAF
         lRNNBkVtYbntBXeKP22klIpEBHG11VvF1A5R9IzDjAhEWRaCmXdZxMcVTMp+yvMvKqHf
         jTW8JGEb7/3KL5ExPrNpQ3IxR5EoFJ5qxQ5eoFGp4Z1z+sctZKYXtABd27rr3q3DQE2C
         KNhmOD+qdCfOF+7JrxCSEuxCAwMNM3d3hTtbjE2s21q7XV34w0FxfNv160WNXYWrwjM5
         iaBadX7T8cnPlX8a9ajOTXjREj15v4QBhPEm83dQRZO2KlMl+QFcZPbCvw50pRFEZdo0
         IqiQ==
X-Forwarded-Encrypted: i=1; AJvYcCWhS0m2reHmEbxNk691JRHuW65qHJqki/SckGlJ7AkZAWnTm8sTRJNs7Ko8/QG9Vg7ocSaCpJjp8L83tlXrjw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzClk6SIdS1JD+32OBjsFQ0p1ogd7R0bqVOfazdUtXHToW4RvQP
	ssvUJqhnWmsJbjaZzSv1MdU/NP90MeW/edUs8WuTxYt79lNEcj3Bp4CWxU7Lu8zt7gypjNprmn9
	HonzVTDMpEEiuWYGoE9bniMMPWEcfsemXkMekLbLGKg+1TyWUf3JeSoBHOZA=
X-Google-Smtp-Source: AGHT+IHtEJYalFaGQmYX15vQQch53DYo1fzoJ/ko2WfRelsuQZ02DqKU9rKYm2SO1tI4ttlniyWpNJsgxDRgNOJ4FRZHeRddCBzA
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144f:b0:3df:4c0a:a3 with SMTP id
 e9e14a558f8ab-3e253363d95mr464635ab.20.1752165603797; Thu, 10 Jul 2025
 09:40:03 -0700 (PDT)
Date: Thu, 10 Jul 2025 09:40:03 -0700
In-Reply-To: <686ea916.050a0220.385921.0013.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <686fece3.a00a0220.26a83e.0018.GAE@google.com>
Subject: Re: [syzbot] [bcachefs?] kernel BUG in bch2_btree_node_iter_init (2)
From: syzbot <syzbot+3ba6dd3d414ec2296f3c@syzkaller.appspotmail.com>
To: anna.luese@v-bien.de, kent.overstreet@linux.dev, 
	linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit c366b1672d74cb008974f6e36e34dc191621f3bb
Author: Kent Overstreet <kent.overstreet@linux.dev>
Date:   Sat Apr 26 13:31:23 2025 +0000

    bcachefs: btree_node_data_missing is now autofix

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=128dda8c580000
start commit:   733923397fd9 Merge tag 'pwm/for-6.16-rc6-fixes' of git://g..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=118dda8c580000
console output: https://syzkaller.appspot.com/x/log.txt?x=168dda8c580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=bd2783a0a99d4ed0
dashboard link: https://syzkaller.appspot.com/bug?extid=3ba6dd3d414ec2296f3c
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=12101bd4580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12609a8c580000

Reported-by: syzbot+3ba6dd3d414ec2296f3c@syzkaller.appspotmail.com
Fixes: c366b1672d74 ("bcachefs: btree_node_data_missing is now autofix")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
