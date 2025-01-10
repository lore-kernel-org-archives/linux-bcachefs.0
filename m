Received: from mout02.posteo.de (mout02.posteo.de [185.67.36.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3DEB20A5FC
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 22:49:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736549392; cv=none; b=pxsJpKdfiBQ/vTi/vQNHtB0BRx2kwjR46sdIW/obSjw/ilarstrnpFt4Q+7mplEYuARucivRbTeDLs9AhpgG1IDKbQXS4LKRlWAj8sn4LZygzUqYcaQ1lCu0LtEM/Fi1QNLT6bIl1I6TUBuvxTg/l6iQYd2CED8r9Sa8nqF8hRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736549392; c=relaxed/simple;
	bh=8DJZqMYftnNlyCSAFzZHG07vI093eOJ9tzBX7Me5ORU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P6E3mldJuczNF1msfzJuG2yA1jxXF5Qe23on5ZUOozt4yAUYX629n8CU9fmChK+v7irNNCpxIqPKzTje3ewR9mbA8A6GbnSY8w5Ih/SdNOfz8bSWYMnWCpzl0YT9DYmyx/6Ukjd5bj2Z4MpbvAsoeLJzGLO7B66bUt6j2hYFeTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net; spf=pass smtp.mailfrom=posteo.net; dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b=p0QTZ/Or; arc=none smtp.client-ip=185.67.36.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.net header.i=@posteo.net header.b="p0QTZ/Or"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout02.posteo.de (Postfix) with ESMTPS id DA846240101
	for <linux-bcachefs@vger.kernel.org>; Fri, 10 Jan 2025 23:49:47 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.net; s=2017;
	t=1736549387; bh=8DJZqMYftnNlyCSAFzZHG07vI093eOJ9tzBX7Me5ORU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:From;
	b=p0QTZ/OrOmJuKqeig6bNDleBad2rLvNi3LnYstJLU18TKLc/DysBe4FshwxUZ5tb/
	 0DqRRTYkVA01w+fblcS/Dsy0g20SpmsQXuVj0+1Zg+oRqIfVbDLOqznlXhZwFQbEBV
	 zQSDwcuzq0nuv2V8TYjkx21WcOgpwhGZYhtF/qagjxQfOAKdSxQ49Vt2By/Qn9hcza
	 GDTpow7gM0zcj+K0AVQjbS+ARUjgaQVDZ0OPr+yxcm/q/ceciqs5rq67FqgFEYSqVX
	 UEBUrdWYckuJiAHdBASqUw/ZY8Z1LH5sPiOLS4SNayvRLiVi1jjzZ0/ukOWdAJmiEt
	 qnWtHa7lEZhng==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4YVH0W2zxxz6tyL;
	Fri, 10 Jan 2025 23:49:47 +0100 (CET)
From: =?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
To: linux-bcachefs@vger.kernel.org
Cc: kent.overstreet@gmail.com,
	=?UTF-8?q?Thomas=20M=C3=BChlbacher?= <tmuehlbacher@posteo.net>
Subject: [PATCH 9/9] feat(nix): add a CI check that builds on 32-bit
Date: Fri, 10 Jan 2025 22:49:12 +0000
Message-ID: <20250110224912.445491-10-tmuehlbacher@posteo.net>
In-Reply-To: <20250110224912.445491-1-tmuehlbacher@posteo.net>
References: <20250110224912.445491-1-tmuehlbacher@posteo.net>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Picked armv7l-linux but i686-linux would probably also work. Not sure
which one is more important to check for.
---
 flake.nix | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/flake.nix b/flake.nix
index 62bf40ca..26719d00 100644
--- a/flake.nix
+++ b/flake.nix
@@ -276,6 +276,8 @@
               }
             );
 
+          checks."32-bit" = config.packages."${cargoToml.package.name}-armv7l-linux";
+
           devShells.default = pkgs.mkShell {
             inputsFrom = [
               config.packages.default
-- 
2.47.0

