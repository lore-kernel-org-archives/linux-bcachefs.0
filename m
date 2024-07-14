Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1B94D27D;
	Sun, 14 Jul 2024 17:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720977694; cv=none; b=BavhLtCrcUXL7idEhnno/ejMIfUswGPKwg/LR5ZfML1UFP0KqPDfADNTO7pGSvs2cVvdNzzPMQfz1Kb9icSxQ+hG+VTiehFsESTcrmYQigKbC3mRzgi9axBdEVqerrh7fy+LVngSUS8hHsKoDvsnUNlEo754DL7olMvqV0ZBPVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720977694; c=relaxed/simple;
	bh=J/Qb0gThL4j3Uoyg4Clycpw/2i361PZ/NXwbE5C+AdA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=nru13Jj5+94m7o0o+CS8pkPwUqmOYpah63FOGQzZb5GMn/nD3JFUHdFXH/bzeA2wS5tilcCCLXPVsq306sKwn+he/Ms9eT98jJcSMAqXD1lI1MDKP9DQbyTSL5AvhctiQnt60b9fhgc23v8Di9FEe/r2sXN7y1YOk8Qw1rzz3+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=kzxOghUJ; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="kzxOghUJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1720977679; x=1721582479; i=markus.elfring@web.de;
	bh=HasxCNi8X2ES8SdbqnOhQdJu4uUx4nqIQPp3FXMVmwM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:From:
	 Subject:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kzxOghUJjuaMLikY/UBX4DlYWZutn+E5Ay5fPraBklsxx7Amo0SUPhajwPYgupfK
	 3k3pz+2f2svdgVRsSPp4UOhli4/JAEOloaXJVO/nN0RuSDXaXtfI5jB/e55AB5f5+
	 yrCU92sbKXOA73uic/ye9D1FoLFalgmmu4R9wtG0Ut5TeMUeSWwtoboZQ5U1rxjk5
	 amqL2SDI6CGK9vEv1d8EiNj4OvClgXkf0lMHbuIrBQNp8kzOs6YrQ3F2mX8cVfRNf
	 2k498EqspDbo90tiGAYTPxKVW4ZEyVLcgojNyqWwGpKBBlR/nJFRBoxGRgvWp7PHF
	 Ai9amYbuAWQQ9z8IHw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.21] ([94.31.82.95]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1M1JF8-1sVmzt01ne-007Wmj; Sun, 14
 Jul 2024 19:21:19 +0200
Message-ID: <e7faa2c4-9590-44b4-8669-69ef810277b1@web.de>
Date: Sun, 14 Jul 2024 19:21:15 +0200
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-bcachefs@vger.kernel.org, kernel-janitors@vger.kernel.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Kent Overstreet <kent.overstreet@linux.dev>
Content-Language: en-GB
Cc: LKML <linux-kernel@vger.kernel.org>
From: Markus Elfring <Markus.Elfring@web.de>
Subject: [PATCH] closures: Use seq_putc() in debug_show()
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:GlPPVpVcPkDvHKYCv9ecKXn3hbWN+tB5jvLUZIDnE10agGYcK78
 WHARB7tDHFffsi9kqmY+ikWnfuymy33IwD7E6O7bY0LgQ3LC+l2DYF2dsIBD2qjV7VUEl9M
 qN29R6gEPXv6w/2ehvX94JU3DmsKCNLrs4fFFR+rN50edNwERtzlGqd4LQaSDpc2uL96Wyh
 ff517mIW3f6VoOg273smA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Jl44Y2fzuiI=;u2+82f0/AgxuwZ3lMVZosGizwns
 oc5BoV2dep02vAKKQqaSJ5SkSsaXjgZ24bXf8X44dRX4frv6CGfEhC0d0Tqw95uPnAAHSAGxo
 inE5ktrZ/O9JMozWg/peiq8Veixgws9qLDJkB+RqHN3uY+bdeVtoSB0BxPFTB0Y1e3gI4JTc3
 II5/R/cn5pfhJmFq3DN8FjPudo5/RawMp0sV7wCE4SSlYZiUmDy+jtIbzybDcm4NbsBvVoQeQ
 Slv4cVg8SF2cnJVWqzBcsk8bfGctrle6hvd8GA83mzv5M+lTnrgsKqOuYqOUXmYGCoDtr3o39
 RuoALiMuxgnCHZFvZTAdWgSi66GOrzTuzv4s77j644/nIhJUpRaJfBvtbH5XMwtzkH3yrDrsO
 TVWLlqS1RG+G8NI+4+iQ1AsUBEYSlRciuYSeogDtsznbhLRvszosdCBkC4fBASixNlelwBhuB
 4slyudD9/tuuRwfp6iS9AuybnL8GBvJHcihcrkeyvMxqP/Mn86SELNsA2RBQ7sFHgnKDNFEwI
 1T6v5+X56dgQgaRJLcwc+lm5/MLXmax9pRzrTOJS7kqujKmfMee4PUK90gm5w7l72uoWiK+qD
 B4ffXF5Z2DoauX4gPkFL/Sd6XLHZTSl5C9DWIO8GYWyzQsTyo3Ocpo/ghGWFot2QBHsbdgjOr
 TxnztqHyU22V4afVTnSUbCWyfRiG6AVBovNIN+jZb9RzTTXb3a6uNnaIl4bXfeMEE58BBRcVw
 TT1y4oe3klNO3RgWMO5C7NOx52bHTT8uZ9CcbLxhwaPjR7SqjWGoBr6rxlljoUDCO85asPLIu
 6zMfyt2rH9h2N4mZyDk8ZOdg==

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Sun, 14 Jul 2024 19:15:09 +0200

A single line break should be put into a sequence.
Thus use the corresponding function =E2=80=9Cseq_putc=E2=80=9D.

This issue was transformed by using the Coccinelle software.

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
=2D--
 lib/closure.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/lib/closure.c b/lib/closure.c
index 116afae2eed9..2bfe7d2a0048 100644
=2D-- a/lib/closure.c
+++ b/lib/closure.c
@@ -278,7 +278,7 @@ static int debug_show(struct seq_file *f, void *data)
 			seq_printf(f, " W %pS\n",
 				   (void *) cl->waiting_on);

-		seq_puts(f, "\n");
+		seq_putc(f, '\n');
 	}

 	spin_unlock_irq(&closure_list_lock);
=2D-
2.45.2

