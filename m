Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460A7135A5D
	for <linux-bcachefs@vger.kernel.org>; Thu, 25 Jan 2024 20:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.70.40.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706213461; cv=none; b=MXz0Isrago+EdOjbd7cspG/E/TMH308/eL0iDijtnwKnZXZD8Sf41ZoMoS6Rigc3c/3WDuQcI/FQgBVZT/ZkPKRa0Zz8vxVkPBHqQHFg46LE62GLUETvaQOPjZnboWdXePZ3DjUpzhY4tzKe/KELO6B0J8crjCstqtShFpsVoE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706213461; c=relaxed/simple;
	bh=u1LLf1cGm6NKtGU9QV2vl36eYjmM5X7OQrOW497t1Zg=;
	h=Date:To:From:Subject:Message-ID:MIME-Version:Content-Type; b=h737/UsgKcwIm0V+bwz+YxIykSHBOR16jsG53aUC3DD5lnSaqfRK25Qw7ALofvbfThsUn4VlSP+1jl/QMGVxbrPRTFcnmli+3RtqbutI7EghAUKFfsfI7EWCBpM5AHS3mwlyPxEmqHSIwm7oJ4MxE9CKc+fgy2n7udsaW4dmc70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com; spf=pass smtp.mailfrom=protonmail.com; dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b=HZuBEYtJ; arc=none smtp.client-ip=185.70.40.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=protonmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=protonmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=protonmail.com header.i=@protonmail.com header.b="HZuBEYtJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1706213450; x=1706472650;
	bh=u1LLf1cGm6NKtGU9QV2vl36eYjmM5X7OQrOW497t1Zg=;
	h=Date:To:From:Subject:Message-ID:Feedback-ID:From:To:Cc:Date:
	 Subject:Reply-To:Feedback-ID:Message-ID:BIMI-Selector;
	b=HZuBEYtJOANNsyr802Hp+JWTO5D85Rxyl0ISzkHJ2NMsY63QszyWLAWmq3DzW3f1v
	 F8RoqRd7OkS+y3JQuKpxre0irErOKTZDOyecACbpfqYporFdLNWFoy0KewjmoQOjn6
	 GsP9TeKNXWGIlcMom3FOiBW9S3a6pBKCz/cn8b1XfBIoRNlDyEVazKPPdkDvBimPZN
	 pSMyFe2W0IfYy4ix7A8AovPybEqbkmaO3op8OC/aYb3KNKX6w2rXEHE6wZ+R3cCNsl
	 dkH2562J7RiJEd7kcS1xvwmoQlPQyfcaGTDL9CjYm/oXczbU+roKX8cH0vSOfAXJfL
	 OglU+GAsyuISQ==
Date: Thu, 25 Jan 2024 20:10:25 +0000
To: "linux-bcachefs@vger.kernel.org" <linux-bcachefs@vger.kernel.org>
From: RlndVt <RlndVt@protonmail.com>
Subject: Mounting a encrypted disk: Fatal error: Required key not available
Message-ID: <Xp4_NQrvvUiIrrXXHjmhCQLmGSM2uRzN3CKOAHr1e1oridV3HcuggbV_xzRf4uNm7ASyP1QWITqf1zUtONlDh43tNRoKYHYS1hgD1kQxKoY=@protonmail.com>
Feedback-ID: 63185315:user:proton
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi,

I'm having difficulties mounting a new array I've created:

# bcachefs mount /dev/sde /mnt/vault/
ERROR - bcachefs_rust::cmd_mount: Fatal error: Required key not available

This array was created using:

# bcachefs format --block_size=3D4k --encrypted /dev/sde

And unlocked with `bcachefs unlock`.

The host is running fedora 39 with kernel 6.7.0-200.fc39.x86_64 and bcachef=
s-tools-1.4.1-2.fc39.

Sorry if this isn't much to go by, would love help getting this working.

Thanks in advanced,
Roland
