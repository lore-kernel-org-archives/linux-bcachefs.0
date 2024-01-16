Received: from sonic316-48.consmr.mail.ne1.yahoo.com (sonic316-48.consmr.mail.ne1.yahoo.com [66.163.187.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858C41D523
	for <linux-bcachefs@vger.kernel.org>; Tue, 16 Jan 2024 23:45:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=66.163.187.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705448737; cv=none; b=QizGrI/GehGraQmB0i5TgtsqWwZvWc052FknjUAmjWI/7du0TqBAcq2WDpbmf5zfEjh2eQ8ueCKP/R3ovXCDtbQoGo0G6+MIeJpQwzTOfExOeFXO2McwpdOgruFhwIpf5i6rIlq4CmR85S6wWKHczF3a+sxFzI3tM/8yUalfX4s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705448737; c=relaxed/simple;
	bh=l0dqtQtbifjeAnRKD7QFKARmS3NDjI20Sf+Kwhe+72M=;
	h=DKIM-Signature:X-SONIC-DKIM-SIGN:X-YMail-OSG:X-Sonic-MF:
	 X-Sonic-ID:Received:Received:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:MIME-Version:Content-Transfer-Encoding:References; b=mt9StKIeTQcBLy4lFbf2NFhlQI4pqGdXYB4tRKBBB7Pi8cbFmyxhyLK1XgMx2u7vLwDGiDtUU4owxKszgOqghFxsogj0iCxJDzDiqPJmwZ4GxDaRmjcC9FbpN4JjB2srtR1hSQr4IAuJbOtIaTz0AxtO7jYRXbt2ppvhoYAQoDw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.ca; spf=pass smtp.mailfrom=yahoo.ca; dkim=pass (2048-bit key) header.d=yahoo.ca header.i=@yahoo.ca header.b=Q7l08cp5; arc=none smtp.client-ip=66.163.187.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=yahoo.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=yahoo.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.ca header.i=@yahoo.ca header.b="Q7l08cp5"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.ca; s=s2048; t=1705448734; bh=5B1t6dpUlXWr+45+8diutOIdqdb0qbn4lktqZf9YFI4=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=Q7l08cp5uXelJ8qv5JDu2uvmKlG/SBVM7AZdZV2IfOl8/hPJGJLApNBn9L8IuFjpy1KbX8m6Jm3Ug3OZADqaUpwBN5FKZo+2AmwicgmiieyOIIBpfKoQ/Lf6OF0WXKtDTvx7gnH2y8plXVV8jDbJ0PAPXo1EnwthygJuzmXb3vkZ/G1jSwIaBXUjraitWN+ZuDxic2GyWC8/ZUSkkvWtIR7i0JRlTkce6rsckyANlK3by9TaE0K06iAwf82FFTWsoeHbD+jh/9BV5GCL31v/XKE/7B/s/OlFSe4AeIJTv+7nIWcJ4uTCgZHRUz0shd+wyqmXoyeIk6V3vTZp7tCX0g==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1705448734; bh=pmyKxXQMN51XoIVWCBJaYL/VFpbeXRWfc3JGotRVBxb=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=KVjp73Ydw1BFNPcrylbRnl1h1ngMoL62HpThiy/8I3zawBAs6SX9qAfeD/fsQkpr1TjoQaQCzrDFpxnIoBBJuN3mTXi+v6QpQXthQndzF0U1khDfH8VtPHjTn7z9I7MY1QaQquevzNdUjDaHGEvNkNu3BogsjXYPf4bPeeL/1KQKB+NueMTTte5mkpt6djK2eQT6l2OLUVPEAdepRGV33qlrnEn9KzdmqYSr/LelfRG2hO9XOesC8QUqYQlexJKadH7o703y8ziQvEi5UR3j1AcE4pjwG2dvvHLPKHaskk2uMqcQhEFbFH94GFOPZbesuw60uX36eD1DjI6BZGFkEg==
X-YMail-OSG: BR2IYv4VM1n2WyhpCjHdbzDNes6t4yFxIn.tktpPjWnNOTnt2zz7B.hOJoaBRzY
 5gU19tJBXEU_gQszbk4bnLEmSLDnr1JskTP7hE3HTcyzWfNNDZG4T6rtzt85g1L32ebOjujyEDi8
 oF7l9t19I76a0g203aPXP6P.6MiQ4my6I3U4MlDmJp19Sb5XGNkeyOBVmUJjzqzw.gV.XWEXGqEc
 LC1fA_6.AFXuK8_AM3SvuPkgvHX6j_EslcqSIiom_LaBAFAqkGYR79fT0KJ01RtF2vssqescu2o1
 WZgfjkaZd.nOQugbkgIaaQDngGJjcHfABQtRiC_Ru2ODEIQclLAxvNlJOdzBvKveglf6w88t6ny6
 OyFtaxJ7cAmA2Y7wSygV8HMCfT8oQ_4fIZWWZcxy0qSR7RFk61SP45W11xPqNZ73iBNpz5XoiY0t
 PU9Gh8LyFFu0tV.mFCrWjNDcFi_jW3ldvwp5p1ExI8dZqvcxthlEgtX9wAWcH1Oq15W478my1TIt
 JGS6oSqDD3G7udEYGHtL1KdZugrTHPwKTsjsmZP9JZ18PO8f7eWSIO3R4VcVdwjhfIIr1cateGbE
 pvBziLgq6OtMvFd9a5EuGrGEjbCBFPK_c3dQG5F0ri4dWukyiCmXOXDHP7xI.MTmNI2lkuo3ryto
 NnICKuRy2igKsKMLF9oA9CSZ0KIKZznsJeldJKT4YHETK50QqKjijdKSiSxQSzwo7nlAkkalBEtz
 iqVEPt4GvhVuZQWriVToAxPAnTX9puxsQpMfVj.XH.7daQQMKpoOr3XfkTsBZd_nZ0PMHaL6yCM7
 cVwRaORYeJt6n9arqaFOQ6glZ4NOqFjZ5Mh8M58qmm.MEfk7jBhmbkHljjow5v5FWovnV0SZLt21
 NnnzY7ZTHemdaDxrJWfuXFV2XZVYjbl19oOgh7a7VLIyf0l3eW4_GjU9tpKlLZqwlTxjBr0_DGMX
 kf.6Wkx17eJidxuE_E4.PIBlH6gCJc9wgzNNs6lkpMpYlH22nTla83YRF_SBurTJO1N8JieSuu62
 wC1MKB7L9gxTQFJI8hEReo8Wh7neNu63_GjtTGzZLJLX4N3bkFOIy8OncqPVnSdcCj69gnrNR8ls
 uGAPg_s9pJkViR8quN9yCUh4XmV5tTJsHfzVKo_iuYWnUuBG7zZSQYEXWjvlcnD3.x9EUXbv2KKQ
 vLDdjjoFPkH4NXX5S5nlm6aUb4SezvxUpz6tFEu3KQ9TXRAHsbhnhkC6o1eWIiM1h2IAK151ZU2d
 FJVAdoBMm2ULmG4HWt5VRiquP959ephDWI9MXoXox0J3uXh93X7Wc9zrhLtFgS6qAoLiy8.xjFN9
 XlTLdoHC4Md5MepLb6_MQug.QFFZcm85M9X2vAIYq7JmygcHqHQwv0_MURKWtquTZo.ukTqOHo4G
 sLAUaBud2bvEzGLV_F4qO0iaROnT_JJzw2RKaSF_knY84Z20lc6FrtnBUslrIP6y8tkdNgnmSQfl
 AXQ2kjfzmnbbeMnIjr4hZV_acdGEC9naop.9m1yyYPsDUhidWSuIcf_bFfuNfmY4jox0ztjy2TAF
 QvMelLQ9lMlGQHolGi4vdZjyk9bK3_85AU9UZsrNfdL6fLKGYB_Q3Y_uYYoostW8mijCq_CiUajt
 i43Tgso._nh.bxOCHwYxcU27HumunP1NXrwiCx27prOJvd5GrCVkExsxaCEihsDo9pL58wMcRwiB
 YnmgDnt9SMe3HkdZJr70dK3xaItgevxLgci5NO0bWBVdyBz1a5192O9ywk5NymG8m8xI5zzH3O5M
 Af4CzkbL8Ez6DT0u8O8OHa7BOuT4Wj88otl9Orrz7tfnjFRlbqptSCsBCTxOKhJZWUFo3hjxaiOs
 04Ksyz9ID9hdqp6jyc9UnrACj9HJ6halbFXPhOFxeKe_pXb.TPczc1hxdi3_JqeMEq.tJwJ0xP5r
 cunZCQ1n8VHqmN8hnsk5MXddLbGxkTM3k6eNHC5zEq2i6deIiLcSzPk9vAFwIuxrVOk1ly_Evb0.
 5BwKXt76dpqJIE52E_Pv955MhhjIiZdJrZZ.JUekOjDUvXGhRlfuOzSr6iKyRSoMl1O5eXT6reQV
 Qofr9hCElWcULZJcr0MCWcfnMaFpKgcn_tuC7pJoUNza6qPQMfn23Ko8CilzREoZF.jshtptUYge
 8_8f15wm.VTyHnyqQmvkJPrJP.y8nxvF2PpOEIThRlKdlSLPldh87L.Vj3fOffZ1BmFA_MOd4xuo
 PBYQ3Mma.suzwzPxU1qZCtwLOaaqAvfBk8A--
X-Sonic-MF: <alex_y_xu@yahoo.ca>
X-Sonic-ID: 38943184-fb37-4028-be00-f4ecf33e665b
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Tue, 16 Jan 2024 23:45:34 +0000
Received: by hermes--production-bf1-59b8649b59-br8kc (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 2f9d556b7d6e1c98502f7669667b916b;
          Tue, 16 Jan 2024 23:43:32 +0000 (UTC)
From: "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
To: kent.overstreet@linux.dev
Cc: linux-bcachefs@vger.kernel.org,
	"Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
Subject: [PATCH] bcachefs: call function with semicolon, not comma
Date: Tue, 16 Jan 2024 18:43:09 -0500
Message-ID: <20240116234309.161341-1-alex_y_xu@yahoo.ca>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20240116234309.161341-1-alex_y_xu.ref@yahoo.ca>

Technically the comma is equivalent here, but it's confusing and will
break if it becomes the last line in the block.

Fixes: e99d90c4977 ("bcachefs: fix incorrect usage of REQ_OP_FLUSH")

Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
---
 fs/bcachefs/journal_io.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/bcachefs/journal_io.c b/fs/bcachefs/journal_io.c
index f074a6205bf8..7b2256e18132 100644
--- a/fs/bcachefs/journal_io.c
+++ b/fs/bcachefs/journal_io.c
@@ -1989,7 +1989,7 @@ CLOSURE_CALLBACK(bch2_journal_write)
 
 			bio = ca->journal.bio;
 			bio_reset(bio, ca->disk_sb.bdev,
-					REQ_OP_WRITE | REQ_PREFLUSH),
+					REQ_OP_WRITE | REQ_PREFLUSH);
 			bio->bi_end_io		= journal_write_endio;
 			bio->bi_private		= ca;
 			closure_bio_submit(bio, cl);
-- 
2.43.0

