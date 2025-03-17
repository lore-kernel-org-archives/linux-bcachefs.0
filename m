Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FDC023AD
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 21:12:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742245953; cv=none; b=flljb8n359mD6E3fGDM9VNX62tHSvWHP09ncjtEdP0/nvgHt3kcubqbsdoTO+b78BweRSWoe+h/CtsbbHnirh1oX/Vbyj18LSJm8C8aEDkm+UX9bbS1fsQ3aypw2t5iIqCv8WCP8PGU2YtTdHu51hZsNuw3PmTtV7QFo0i7ku+Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742245953; c=relaxed/simple;
	bh=o7zCnscnjZKCKbwEEgECGvVTASgK34J8wTl026c8hx4=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Subject:
	 In-Reply-To:References; b=fPWSRkPm3tyCweygDop89Q9otkaeuAIWJXW4Fq0/nz7H9a3W/D0jM439aHEvZ1vBKDXVqyCZwAkgvVhcv5wC1MZKbNJB10wqyiP/FLwgqpZGHaJXtTwPc3qwjTP0gflWTLZahZCK5fUNvvQrLAhdQOZD3lIxOba/iJL28oNg6ZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 79D711E4AB
	for <linux-bcachefs@vger.kernel.org>; Mon, 17 Mar 2025 17:12:31 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 1256BA0E7A; Mon, 17 Mar 2025 17:12:31 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <26584.36927.6100.282713@quad.stoffel.home>
Date: Mon, 17 Mar 2025 17:12:31 -0400
From: "John Stoffel" <john@stoffel.org>
To:     linux-bcachefs@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: errors compiling bcachefs-tools v1.20.0 on debian 12
In-Reply-To: <26584.35900.850011.320586@quad.stoffel.home>
References: <20250311201518.3573009-1-kent.overstreet@linux.dev>
	<26584.35900.850011.320586@quad.stoffel.home>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)


Hi guys,
I'm trying to upgrade the bcachefs tools since I tend to use newer
kernels on my Debian 12 system.  The debian packages bcachefs-tools
are ancient.=20=20

So I cloned the repo, installed the pre-reqs and I'm trying to compile
it, but I get the following:


quad:/bcachefs/bcachefs1/bcachefs-tools$ make
    [CC]     c_src/bcachefs.o
In file included from ./libbcachefs/bcachefs.h:202,
                 from c_src/tools-util.h:21,
                 from c_src/cmds.h:10,
                 from c_src/bcachefs.c:26:
include/linux/srcu.h:10:41: error: return type is an incomplete type
   10 | static inline struct urcu_gp_poll_state get_state_synchronize_rcu()
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h: In function =E2=80=98get_state_synchronize_rcu=E2=80=99:
include/linux/srcu.h:12:16: warning: implicit declaration of function =E2=80=98start_poll_synchronize_rcu=E2=80=99 ]
   12 |         return start_poll_synchronize_rcu();
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h:12:16: warning: =E2=80=98return=E2=80=99 with a value, in function returning void [-Wreturn-ty]
   12 |         return start_poll_synchronize_rcu();
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h:10:41: note: declared here
   10 | static inline struct urcu_gp_poll_state get_state_synchronize_rcu()
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h: At top level:
include/linux/srcu.h:25:99: error: parameter 2 (=E2=80=98cookie=E2=80=99) has incomplete type
   25 | bool poll_state_synchronize_srcu(struct srcu_struct *ssp, struct urcu_gp_poll_state cookie)
      |                                                           ~~~~~~~~~~~~~~~~~~~~~~~~~~^~~~~~

include/linux/srcu.h: In function =E2=80=98poll_state_synchronize_srcu=E2=80=99:
include/linux/srcu.h:27:16: warning: implicit declaration of function =E2=80=98poll_state_synchronize_rcu=E2=80=99;]
   27 |         return poll_state_synchronize_rcu(cookie);
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~
      |                poll_state_synchronize_srcu
include/linux/srcu.h: At top level:
include/linux/srcu.h:30:41: error: return type is an incomplete type
   30 | static inline struct urcu_gp_poll_state start_poll_synchronize_srcu(struct srcu_struct *ssp)
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h: In function =E2=80=98start_poll_synchronize_srcu=E2=80=99:
include/linux/srcu.h:32:16: warning: =E2=80=98return=E2=80=99 with a value, in function returning void [-Wreturn-ty]
   32 |         return start_poll_synchronize_rcu();
      |                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h:30:41: note: declared here
   30 | static inline struct urcu_gp_poll_state start_poll_synchronize_srcu(struct srcu_struct *ssp)
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/srcu.h: At top level:
include/linux/srcu.h:35:41: error: return type is an incomplete type
   35 | static inline struct urcu_gp_poll_state get_state_synchronize_srcu(struct srcu_struct *ssp)
      |                                         ^~~~~~~~~~~~~~~~~~~~~~~~~~
make: *** [Makefile:171: c_src/bcachefs.o] Error 1
quad:/bcachefs/bcachefs1/bcachefs-tools$ git branch
  master  * v1.20.0
